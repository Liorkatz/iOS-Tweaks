include /opt/theos/makefiles/common.mk

BUNDLE_NAME = UnAlarm
UnAlarm_FILES = UnAlarm.mm
UnAlarm_INSTALL_PATH = /Library/PreferenceBundles
UnAlarm_FRAMEWORKS = UIKit
UnAlarm_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/UnAlarm.plist$(ECHO_END)
