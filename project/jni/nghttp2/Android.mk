LOCAL_PATH:=$(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := nghttp2

LOCAL_MODULE_FILENAME := lib$(notdir $(LOCAL_PATH))

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SRC_FILES := lib-$(TARGET_ARCH_ABI)/lib$(LOCAL_MODULE).so
LOCAL_BUILT_MODULE := # This fixes a bug in NDK r10d

include $(PREBUILT_SHARED_LIBRARY)
