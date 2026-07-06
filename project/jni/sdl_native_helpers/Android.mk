LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := sdl_native_helpers

ifndef SDL_JAVA_PACKAGE_PATH
$(error Please define SDL_JAVA_PACKAGE_PATH to the path of your Java package with dots replaced with underscores, for example "com_example_SanAngeles")
endif

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../sdl-$(SDL_VERSION)/include
LOCAL_CFLAGS := -DSDL_JAVA_PACKAGE_PATH=$(SDL_JAVA_PACKAGE_PATH) -DSDL_CURDIR_PATH=\"$(SDL_CURDIR_PATH)\"
ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
        #LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384
        LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384
endif
ifeq ($(TARGET_ARCH_ABI), x86_64)
        #LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384
        LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384
endif

LOCAL_CPP_EXTENSION := .cpp

LOCAL_SRC_FILES := repoNatives.c

LOCAL_SHARED_LIBRARIES :=
LOCAL_LDLIBS := -llog

include $(BUILD_SHARED_LIBRARY)
