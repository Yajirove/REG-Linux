################################################################################
#
# mupen64plus-gliden64-plugin
#
################################################################################
# Version: Commits on Nov 25, 2024
MUPEN64PLUS_GLIDEN64_VERSION = d5be3c6086bdf94baa52b54f155092563085624c
MUPEN64PLUS_GLIDEN64_SITE = $(call github,gonetz,GLideN64,$(MUPEN64PLUS_GLIDEN64_VERSION))
MUPEN64PLUS_GLIDEN64_LICENSE = GPLv2
MUPEN64PLUS_GLIDEN64_DEPENDENCIES = sdl2 alsa-lib mupen64plus-core libpng zlib
MUPEN64PLUS_GLIDEN64_SUBDIR = /src/

MUPEN64PLUS_GLIDEN64_CONF_OPTS = -DMUPENPLUSAPI=ON -DMUPENPLUSAPI_GLIDENUI=OFF -DUSE_SDL=ON

# fix for PNG relocations issue
MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DUSE_SYSTEM_LIBS=ON

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DEGL=ON -DGL_PROFILE=ON
	ifneq ($(BR2_PACKAGE_XORG7),y)
	    MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_C_FLAGS="-DEGL_NO_X11"
		MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_CXX_FLAGS="-DEGL_NO_X11"
	endif
endif

ifeq ($(BR2_PACKAGE_MESA3D),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DMESA=ON
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCRC_NEON=ON
endif

ifeq ($(BR2_aarch64),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCRC_ARMV8=ON
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
	MUPEN64PLUS_GLIDEN64_RELTYPE= Debug
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
else
	MUPEN64PLUS_GLIDEN64_RELTYPE = Release
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
endif

define MUPEN64PLUS_GLIDEN64_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/mupen64plus/
	$(INSTALL) -D $(@D)/src/plugin/$(MUPEN64PLUS_GLIDEN64_RELTYPE)/mupen64plus-video-GLideN64.so \
		$(TARGET_DIR)/usr/lib/mupen64plus/mupen64plus-video-gliden64.so
	$(INSTALL) -D $(@D)/ini/* \
		$(TARGET_DIR)/usr/share/mupen64plus/
endef

$(eval $(cmake-package))
