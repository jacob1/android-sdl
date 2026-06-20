#!/bin/bash

ARCHITECTURE=$1
shift 1


echo_usage()
{
	printf "
\033[1mInstructions for use:\033[m

  First, edit this script and change the variables at the start to
  match your ndk installation. Then use these commands to download,
  compile, and install libraries:

    \033[1m"${0}"\033[m \033[4mPLATFORM\033[m make \033[4mLIBRARY_NAME\033[m...
    \033[1msudo "${0}"\033[m \033[4mPLATFORM\033[m install \033[4mLIBRARY_NAME\033[m...

  VALID PLATFORMs are: \033[1mx86_64 x86 arm64-v8a armeabi-v7a\033[m
  Valid LIBRARY_NAMEs are: \033[1mzlib openssl (not preferred) boringssl nghttp2 curl luajit fftw\033[m
\n"
}

case $ARCHITECTURE in
	x86_64)
		HOSTPREFIX="x86_64-linux-android"
		COMPILERPREFIX=$HOSTPREFIX
		VER="21"
		OPENSSL_ARCH="android-x86_64"
		LUAJIT_HOSTCC="gcc"
		;;
	x86)
		HOSTPREFIX="i686-linux-android"
		COMPILERPREFIX=$HOSTPREFIX
		VER="21"
		OPENSSL_ARCH="android-x86"
		LUAJIT_HOSTCC="gcc -m32"
		;;
	arm64-v8a)
		HOSTPREFIX="aarch64-linux-android"
		COMPILERPREFIX=$HOSTPREFIX
		VER="21"
		OPENSSL_ARCH="android-arm64"
		LUAJIT_HOSTCC="gcc"
		;;
	armeabi-v7a)
		# HOSTPREFIX and #COMPILEPREFIX are different for this arch in the ndk for some awful reason
		HOSTPREFIX="arm-linux-androideabi"
		COMPILERPREFIX="armv7a-linux-androideabi"
		VER="21"
		OPENSSL_ARCH="android-arm"
		LUAJIT_HOSTCC="gcc -m32"
		;;
	*)
		echo_usage
		exit 1
	;;
esac

# platform name, for configure scripts
HOST="$HOSTPREFIX$VER"
# prefix for ndk executables. Clang executables are prefixed with sdk version, and the rest are not
CLANG_BIN_PREFIX="$HOSTPREFIX$VER-"
#CLANG_BIN_PREFIX_NOVER="$HOSTPREFIX-"
CLANG_BIN_PREFIX_NOVER="llvm-"
# where to install the libraries
CLANG_INSTALL_DIR="/home/jacob/code/android/ndk-cross-libs/$ARCHITECTURE"
#CLANG_INSTALL_DIR="/home/jacob/code/android/android-ndk-r21/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib"

# Notes on executable prefix names for each architecture
# See: https://developer.android.com/ndk/guides/other_build_systems
#armeabi-v7a	armv7a-linux-androideabi	16
#arm64-v8a		aarch64-linux-android		21
#x86			i686-linux-android			16
#x86-64			x86_64-linux-android		21



# Note: I manually copied all the libraries into my ndk
# /home/jacob/code/android/android-ndk-r21/toolchains/llvm/prebuilt/linux-x86_64/aarch64-linux-android/lib
# This one is special, needs the armv7-a at the end:
# /home/jacob/code/android/android-ndk-r21/toolchains/llvm/prebuilt/linux-x86_64/arm-linux-androideabi/lib/armv7-a


# Note: Still having problems. This might fix it:
#	https://stackoverflow.com/questions/25253823/how-to-make-ssl-peer-verify-work-on-android/31521185
# But tried, and even including ca-certificates.crt into the app was failing, 	


#
# Script to download, compile (including files for static linking) 
# and install libraries for compiling Powder Toy using MinGW, 
#
# Copyright (c) 2011-2013 jacksonmj
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

export AR=${CLANG_BIN_PREFIX_NOVER}ar
#export CC=${COMPILERPREFIX}${VER}-clang
#export CXX=${COMPILERPREFIX}${VER}-clang++
export CC="clang -target ${COMPILERPREFIX}${VER}"
export CXX="clang++ -target ${COMPILERPREFIX}${VER}"
export RANLIB=${CLANG_BIN_PREFIX_NOVER}ranlib
export STRIP=${CLANG_BIN_PREFIX_NOVER}strip
export PREFIX=${CLANG_INSTALL_DIR}
MAKE="make -j 16"

# 16 KB page sizes. Applies to some libs and not all, but I just used ndk 28+ instead which automatically does it
export LDFLAGS="-Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384"

log_error()
{
	error_msg=${1}
	if test "${errors}" = ""; then
		errors=${error_msg}
	else
		errors=${errors}"\n"${error_msg}
	fi
	printf "\033[1;31m${error_msg}\033[m\n"
}

make_lib()
{
	lib=$1
	eval ${lib}_successful_make=0
	eval filename=\$${lib}_filename
	eval url=\$${lib}_url
	if test "${filename}" = ""; then
		log_error "Library name \"${lib}\" not recognised"
		return 1
	fi
	if test ! -f ${filename}; then
		printf "\033[1m${filename} does not exist, downloading...\033[m\n"
		wget -qO "${filename}" "${url}"
		if test $? -ne 0; then
			log_error "Unable to download ${url}"
			return 1
		fi
	fi
	eval md5=\$${lib}_md5
	if test "${md5}" != ""; then
		md5_test=`md5sum -b ${filename} | cut -d' ' -f 1`
		if test "${md5}" != "${md5_test}"; then
			log_error "Incorrect checksum for ${filename}"
			return 1
		fi
	fi
	eval folder=\$${lib}_folder
	eval extractfolder=\$${lib}_extractfolder
	if test "${extractfolder}" != ""; then
		rm -rf ${extractfolder}${folder}
	fi
	printf "\033[1mExtracting ${filename}...\033[m\n"
	mkdir -p ${extractfolder}
	tar -C ${extractfolder} -axf ${filename}
	if test $? -ne 0; then
		unzip -qd ${extractfolder}/${lib} ${filename}
		if test $? -ne 0; then
			log_error "Unable to extract ${filename}"
			return 1
		fi
	fi
	printf "\033[1mCompiling ${lib}...\033[m\n"
	${lib}_compile ${extractfolder}${folder}
	if test $? -ne 0; then
		log_error "Failed to compile ${lib}"
		return 1
	fi
	printf "\033[1;32m${lib} compiled and ready to install\033[m\n\n"
	eval ${lib}_successful_make=1
	return 0
}

install_lib()
{
	lib=$1
	eval ${lib}_successful_install=0
	eval folder=\$${lib}_folder
	eval extractfolder=\$${lib}_extractfolder
	printf "\033[1mInstalling ${lib}...\033[m\n"
	${lib}_install ${extractfolder}${folder}
	if test $? -ne 0; then
		log_error "Failed to install ${lib}"
		return 1
	fi
	printf "\033[1;32m${lib} installed\033[m\n\n"
	eval ${lib}_successful_install=1
	return 0
}


zlib_url="https://starcatcher.us/TPT/libs/zlib-1.2.11.tar.gz"
zlib_md5="1c9f62f0778697a09d36121ead88e08e"
zlib_filename="zlib-1.2.11.tar.gz"
zlib_folder="/zlib-1.2.11"
zlib_extractfolder="tpt-libs/$ARCHITECTURE"
zlib_compile()
{
	pushd $1 > /dev/null
	./configure --prefix=$CLANG_INSTALL_DIR --includedir=$CLANG_INSTALL_DIR/include --libdir=$CLANG_INSTALL_DIR/lib && make
	result=$?
	popd > /dev/null
	return $result
}
zlib_install()
{
	pushd $1 > /dev/null
	make install
	result=$?
	popd > /dev/null
	return $result
}

openssl_url="https://github.com/openssl/openssl/releases/download/openssl-3.6.3/openssl-3.6.3.tar.gz"
openssl_md5="f388d6144fe20b9b2c6bf208280d6ec3"
openssl_filename="openssl-3.6.3.tar.gz"
openssl_folder="/openssl-3.6.3"
openssl_extractfolder="tpt-libs/$ARCHITECTURE"
openssl_compile()
{
	# This patch taken from eighthave's comment on https://github.com/openssl/openssl/pull/8992  (actual PR has syntax errors)
	#patch $1/Configurations/15-android.conf android-ndk.patch
	pushd $1 > /dev/null
	# Does not work, tries using linux x86_64 stuff. Need to specifically call ./Configure with android platform
	#./config shared no-ssl2 no-ssl3 no-comp no-hw no-engine --prefix=$CLANG_INSTALL_DIR --openssldir=$CLANG_INSTALL_DIR/ssl && $MAKE
	
	# Special notes on some args:
	# -D__ANDROID_API__=$VER is required or else you get linker errors for random stuff like stdin: https://github.com/android/ndk/issues/445  (removed it after updating to 1.1.1w because it seems unnecessary now)
	# zlib must be installed first. Unsure if openssl really needs zlib support though, curl has it
	./Configure $OPENSSL_ARCH no-shared no-ssl2 no-ssl3 no-hw no-engine no-stdio --with-zlib-include=$CLANG_INSTALL_DIR/include --with-zlib-lib=$CLANG_INSTALL_DIR/lib --openssldir=$CLANG_INSTALL_DIR/ssl --prefix=$CLANG_INSTALL_DIR && $MAKE
	result=$?
	popd > /dev/null
	return $result
}
openssl_install()
{
	pushd $1 > /dev/null
	$MAKE install_sw
	result=$?
	popd > /dev/null
	return $result
}

boringssl_url="https://github.com/google/boringssl/releases/download/0.20240930.0/boringssl-0.20240930.0.tar.gz"
boringssl_md5="42997d6f9271ef32c073e27684923c7e"
boringssl_filename="boringssl.tar.gz"
boringssl_folder="/boringssl-0.20240930.0"
boringssl_extractfolder="tpt-libs/$ARCHITECTURE"
boringssl_compile()
{
	pushd $1 > /dev/null
	cmake -DANDROID_ABI=$ARCHITECTURE -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake \
			  -DANDROID_PLATFORM=android-${VER} \
              -DANDROID_NATIVE_API_LEVEL=$MIN_SDK_VERSION \
              -DCMAKE_BUILD_TYPE=Release . && $MAKE
	result=$?
	popd > /dev/null
	return $result
}
boringssl_install()
{
	pushd $1 > /dev/null
	mkdir -p $CLANG_INSTALL_DIR/lib
	cp libssl.a $CLANG_INSTALL_DIR/lib && cp libcrypto.a $CLANG_INSTALL_DIR/lib && cp -r include $CLANG_INSTALL_DIR
	result=$?
	popd > /dev/null
	return $result
}

nghttp2_url="https://github.com/nghttp2/nghttp2/releases/download/v1.69.0/nghttp2-1.69.0.tar.gz"
nghttp2_md5="1a4709ee5202a92d3d3e7557d88531fa"
nghttp2_filename="nghttp2-1.69.0.tar.gz"
nghttp2_folder="/nghttp2-1.69.0"
nghttp2_extractfolder="tpt-libs/$ARCHITECTURE"
nghttp2_compile()
{
	pushd $1 > /dev/null
	./configure --host=$HOST --prefix=$CLANG_INSTALL_DIR --without-systemd --without-openssl --with-pic && $MAKE
	result=$?
	popd > /dev/null
	return $result
}
nghttp2_install()
{
	pushd $1 > /dev/null
	$MAKE install
	result=$?
	popd > /dev/null
	return $result
}

curl_url="https://curl.se/download/curl-8.20.0.tar.gz"
curl_md5="4f3a732b55b58a7c223f313510ca27c9"
curl_filename="curl-8.20.0.tar.gz"
curl_folder="/curl-8.20.0"
curl_extractfolder="tpt-libs/$ARCHITECTURE"
curl_compile()
{
	pushd $1 > /dev/null
	CPPFLAGS="-I$CLANG_INSTALL_DIR/include -fexceptions" LDFLAGS="-L$CLANG_INSTALL_DIR/lib -lstdc++ ${LDFLAGS}" ./configure --host=$HOST --prefix=$CLANG_INSTALL_DIR --with-zlib --with-ssl=${CLANG_INSTALL_DIR} --enable-ipv6 --disable-ftp --disable-telnet --disable-smtp --disable-imap --disable-pop3 --disable-smb --disable-gopher --disable-dict --disable-file --disable-tftp --disable-rtsp --disable-ldap --without-libpsl --with-ca-fallback --with-ca-path=/system/etc/security/cacerts && \
	$MAKE
	# --with-ca-path=/system/etc/security/cacerts
	result=$?
	popd > /dev/null
	return $result
}
curl_install()
{
	pushd $1 > /dev/null
	$MAKE install
	result=$?
	popd > /dev/null
	return $result
}

luajit_url="https://github.com/The-Powder-Toy/tpt-libs/raw/refs/heads/master/tarballs/LuaJIT-2.1.0-git.tar.gz"
luajit_md5="38acd902a6359b97a4b1cfab8186323b"
luajit_filename="LuaJIT-2.1.0-git.tar.gz"
luajit_folder="/LuaJIT-2.1.0-git"
luajit_extractfolder="tpt-libs/$ARCHITECTURE"
luajit_compile()
{
	pushd $1 > /dev/null
	$MAKE TARGET_SYS=Linux HOST_CC="${LUAJIT_HOSTCC}" CC="${CC}" STATIC_CC="${CC}" DYNAMIC_CC="${CC} -fPIC" TARGET_LD="${CC}" CROSS="${CLANG_BIN_PREFIX}" TARGET_AR="${AR} rcus" TARGET_STRIP="${STRIP}" RANLIB="${RANLIB}"
	result=$?
	popd > /dev/null
	return $result
}
luajit_install()
{
	pushd $1 > /dev/null
	$MAKE install TARGET_SYS=Linux HOST_CC="${LUAJIT_HOSTCC}" CC="${CC}" CROSS="${CLANG_BIN_PREFIX}" PREFIX=${PREFIX}
	result=$?
	popd > /dev/null
	return $result
}

fftw_url="https://www.fftw.org/fftw-3.3.11.tar.gz"
fftw_md5="40ec8d0447d03b8f01f8c90aa77bd16f"
fftw_filename="fftw-3.3.11.tar.gz"
fftw_folder="/fftw-3.3.11"
fftw_extractfolder="tpt-libs/$ARCHITECTURE"
fftw_compile()
{
	pushd $1 > /dev/null
	./configure --host=$HOST --prefix=$CLANG_INSTALL_DIR --enable-shared --enable-static --disable-alloca --with-our-malloc16 --disable-threads --disable-fortran --enable-portable-binary --enable-float && \
	$MAKE
	result=$?
	popd > /dev/null
	return $result
}
fftw_install()
{
	pushd $1 > /dev/null
	$MAKE install
	result=$?
	popd > /dev/null
	return $result
}


if test "${1}" = "make"; then
	shift
	for lib in "$@"
	do
		make_lib ${lib}
	done
	success_count=0
	fail_count=0
	for lib in "$@"
	do
		eval result=\${${lib}_successful_make}
		if test ${result} -eq 1; then
			success_count=`expr ${success_count} + 1`
		else
			fail_count=`expr ${fail_count} + 1`
		fi
	done
	if test $# -gt 0; then
		if test ${fail_count} -eq 0; then
			printf "\033[1mFinished\033[m\n"
			if test ${success_count} -eq 1; then
				printf "\033[1m${success_count} library ready to install\033[m\n"
			else
				printf "\033[1m${success_count} libraries ready to install\033[m\n"
			fi
			printf "\nInstall with:\n  sudo ${0} install $@\n\n"
		elif test $# -gt 1; then
			fail_list=""
			for lib in "$@"
			do
				eval result=\${${lib}_successful_make}
				if test ${result} -eq 0; then
					fail_list="${fail_list}${lib} "
				fi
			done
			if test ${fail_count} -eq 1; then
				printf "\n\n\033[1;31mErrors occurred while trying to download/compile ${fail_count} library\033[m\n"
			else
				printf "\n\n\033[1;31mErrors occurred while trying to download/compile ${fail_count} libraries\033[m\n"
			fi
			printf "Failed libraries: ${fail_list}\n\n"
			printf "Messages:\n${errors}\n"
		fi
	else
		echo_usage
	fi
elif test "${1}" = "install"; then
	shift
	for lib in "$@"
	do
		install_lib ${lib}
	done
	success_count=0
	fail_count=0
	for lib in "$@"
	do
		eval result=\${${lib}_successful_install}
		if test ${result} -eq 1; then
			success_count=`expr ${success_count} + 1`
		else
			fail_count=`expr ${fail_count} + 1`
		fi
	done
	if test $# -gt 0; then
		if test ${fail_count} -eq 0; then
			printf "\033[1mFinished\033[m\n"
			if test ${success_count} -eq 1; then
				printf "\033[1m${success_count} library successfully installed\033[m\n\n"
			else
				printf "\033[1m${success_count} libraries successfully installed\033[m\n\n"
			fi
		elif test $# -gt 1; then
			fail_list=""
			for lib in "$@"
			do
				eval result=\${${lib}_successful_install}
				if test ${result} -eq 0; then
					fail_list="${fail_list}${lib} "
				fi
			done
			if test ${fail_count} -eq 1; then
				printf "\n\n\033[1;31mErrors occurred while trying to install ${fail_count} library\033[m\n"
			else
				printf "\n\n\033[1;31mErrors occurred while trying to install ${fail_count} libraries\033[m\n"
			fi
			printf "Failed libraries: ${fail_list}\n\n"
			#printf "Messages:\n${errors}\n"
		fi
	else
		echo_usage
	fi
else
	echo_usage
fi


