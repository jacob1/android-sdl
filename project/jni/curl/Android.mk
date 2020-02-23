LOCAL_PATH:=$(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := curl

LOCAL_MODULE_FILENAME := lib$(notdir $(LOCAL_PATH)) # It clashes with system libcrypto and libssl in Android 4.3 and older

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SRC_FILES := lib-$(TARGET_ARCH_ABI)/lib$(LOCAL_MODULE).so.sdl.1.so
LOCAL_BUILT_MODULE := # This fixes a bug in NDK r10d

# NDK is buggy meh
obj/local/$(TARGET_ARCH_ABI)/lib$(LOCAL_MODULE)-sdl.so: $(LOCAL_PATH)/$(LOCAL_SRC_FILES)
	cp -f $< $@

include $(PREBUILT_SHARED_LIBRARY)

