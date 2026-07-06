LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := bzip2

LOCAL_C_INCLUDES := $(LOCAL_PATH) $(LOCAL_PATH)/include
LOCAL_CFLAGS := -O3
ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
	#LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384
	LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384
endif
ifeq ($(TARGET_ARCH_ABI), x86_64)
        #LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384
        LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384
endif

LOCAL_CPP_EXTENSION := .cpp

LOCAL_SRC_FILES := $(notdir $(wildcard $(LOCAL_PATH)/*.c))

LOCAL_STATIC_LIBRARIES :=

LOCAL_SHARED_LIBRARIES :=

LOCAL_LDLIBS :=

include $(BUILD_SHARED_LIBRARY)

