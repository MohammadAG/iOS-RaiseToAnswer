include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RaisetoAnswer

RaisetoAnswer_FILES = /mnt/d/codes/raisetoanswer/Tweak.xm
RaisetoAnswer_FRAMEWORKS = CydiaSubstrate
RaisetoAnswer_PRIVATE_FRAMEWORKS = ChatKit
RaisetoAnswer_LDFLAGS = -Wl,-segalign,4000

export ARCHS = armv7 arm64
RaisetoAnswer_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
	
all::
