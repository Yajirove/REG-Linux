################################################################################
#
# batocera resolution
#
################################################################################

BATOCERA_RESOLUTION_VERSION = 1.2
BATOCERA_RESOLUTION_LICENSE = GPL
BATOCERA_RESOLUTION_DEPENDENCIES = pciutils
BATOCERA_RESOLUTION_SOURCE=
BATOCERA_RESOLUTION_PATH = $(BR2_EXTERNAL_REGLINUX_PATH)/package/batocera/core/batocera-resolution/scripts

BATOCERA_SCRIPT_TYPE=basic

ifeq ($(BR2_PACKAGE_LIBDRM),y)
BATOCERA_SCRIPT_TYPE=drm
endif

ifeq ($(BR2_PACKAGE_REGLINUX_SWAY),y)
#BATOCERA_SCRIPT_TYPE=wayland-sway
BATOCERA_RESOLUTION_DEPENDENCIES += grim wf-recorder
endif

define BATOCERA_RESOLUTION_INSTALL_TARGET_CMDS
	install -m 0755 $(BATOCERA_RESOLUTION_PATH)/resolution/batocera-resolution.drm $(TARGET_DIR)/usr/bin/batocera-resolution
	install -m 0755 $(BATOCERA_RESOLUTION_PATH)/screenshot/batocera-screenshot.drm $(TARGET_DIR)/usr/bin/batocera-screenshot
endef

define BATOCERA_RESOLUTION_INSTALL_RK3128
	install -m 0755 $(BATOCERA_RESOLUTION_PATH)/resolution/batocera-resolution-post-rk3128 $(TARGET_DIR)/usr/bin/batocera-resolution-post
endef

define BATOCERA_RESOLUTION_INSTALL_XORG
	mkdir -p $(TARGET_DIR)/etc/X11/xorg.conf.d
	cp -prn $(BR2_EXTERNAL_REGLINUX_PATH)/board/batocera/x86/fsoverlay/etc/X11/xorg.conf.d/20-amdgpu.conf $(TARGET_DIR)/etc/X11/xorg.conf.d/20-amdgpu.conf
endef

define BATOCERA_RESOLUTION_INSTALL_RECORDER
	install -m 0755 $(BATOCERA_RESOLUTION_PATH)/recorder/batocera-record.drm $(TARGET_DIR)/usr/bin/batocera-record
endef

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3128),y)
	BATOCERA_RESOLUTION_POST_INSTALL_TARGET_HOOKS += BATOCERA_RESOLUTION_INSTALL_RK3128
endif

# REG for kmsdrm look at https://ffmpeg.org/ffmpeg-devices.html#kmsgrab
ifeq ($(BR2_PACKAGE_REGLINUX_WESTON)$(BR2_PACKAGE_REGLINUX_SWAY)$(BR2_PACKAGE_REGLINUX_GAMESCOPE),y)
	BATOCERA_RESOLUTION_POST_INSTALL_TARGET_HOOKS += BATOCERA_RESOLUTION_INSTALL_RECORDER
endif

$(eval $(generic-package))
