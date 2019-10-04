#
# Copyright (C) 2011 The Evervolv Project
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PLATFORM_PATH := device/hp/tenderloin

TARGET_SPECIFIC_HEADER_PATH := $(PLATFORM_PATH)/include

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := scorpion

# Platform
TARGET_BOARD_PLATFORM := msm8660
TARGET_BOARD_PLATFORM_GPU := qcom-adreno200

# Art
LIBART_IMG_BASE := 0x57000000

# Bionic
BOARD_USES_LEGACY_MMAP := true

# Bootloader
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_BOOTLOADER_BOARD_NAME := tenderloin

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(PLATFORM_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_HCI := true
BLUETOOTH_HCIATTACH_USING_PROPERTY := true

# Audio
BOARD_USES_ALSA_AUDIO := true

# Camera
USE_CAMERA_STUB := false

# Compatibilty
TARGET_NEEDS_NON_PIE_SUPPORT := true
TARGET_DISABLE_ARM_PIE := true
TARGET_NEEDS_PRELINK_SUPPORT := true
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
TARGET_HAS_NO_CAMERA_FLASH := true
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x02000000

TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
    /vendor/bin/hw/android.hardware.camera.provider@2.4-service=14 \
    /system/bin/mediaserver=14

# Device manifest
DEVICE_MANIFEST_FILE := $(PLATFORM_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(PLATFORM_PATH)/compatibility_matrix.xml

# Display
BOARD_EGL_WORKAROUND_BUG_10194508 := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
SF_START_GRAPHICS_ALLOCATOR_SERVICE := true
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 6000000
TARGET_DISPLAY_INSECURE_MM_HEAP := true
TARGET_NO_INITLOGO := true
TARGET_USES_HWC2 := true
TARGET_USES_ION := true
USE_OPENGL_RENDERER := true
VSYNC_EVENT_PHASE_OFFSET_NS := 2000000

# GPS
BOARD_USES_QCOM_GPS := true
BOARD_VENDOR_QCOM_GPS_LOC_API_AMSS_VERSION := 50000

# Kernel
BOARD_CUSTOM_BOOTIMG_MK := $(PLATFORM_PATH)/mkbootimg.mk
BOARD_USES_UBOOT := true
BOARD_USES_UBOOT_MULTIIMAGE := true
BOARD_KERNEL_BASE := 0x40200000
BOARD_KERNEL_CMDLINE := console=none
BOARD_KERNEL_IMAGE_NAME := uImage
BOARD_PAGE_SIZE := 2048
TARGET_KERNEL_SOURCE := kernel/htc/msm8960
ifdef RECOVERY_BUILD
TARGET_KERNEL_CONFIG := tenderloin_recovery_defconfig
else
TARGET_KERNEL_CONFIG := tenderloin_android_defconfig
endif

# Media
TARGET_NO_ADAPTIVE_PLAYBACK := true

# Partitions
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16776192
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1375731712
BOARD_USERDATAIMAGE_PARTITION_SIZE := 20044333056
BOARD_CACHEIMAGE_PARTITION_SIZE := 1024
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_REQUIRES_FORCE_VPARTITION := true

# Proprietary
-include vendor/hp/tenderloin/BoardConfigVendor.mk

# Qualcomm support
BOARD_USES_QCOM_HARDWARE := true

# Recovery
TARGET_RECOVERY_FSTAB := $(PLATFORM_PATH)/rootdir/etc/recovery.fstab
BOARD_HAS_SDCARD_INTERNAL := false
BOARD_HAS_NO_MISC_PARTITION := true
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_HAS_NO_REAL_SDCARD := true

# Releasetools
TARGET_PROVIDES_RELEASETOOLS := true
TARGET_RELEASETOOL_IMG_FROM_TARGET_SCRIPT := $(PLATFORM_PATH)/releasetools/tenderloin_img_from_target_files
TARGET_RELEASETOOL_OTA_FROM_TARGET_SCRIPT := $(PLATFORM_PATH)/releasetools/tenderloin_ota_from_target_files

# Wifi
BOARD_WLAN_DEVICE                := ath6kl
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_ath6kl
WPA_SUPPLICANT_VERSION           := VER_0_8_X
