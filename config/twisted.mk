# Copyright (C) 2014-2015 The SaberMod Project
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

# Written for SaberMod toolchains
# TARGET_SM_AND can be set before this file to override the default of gcc 4.8 for ROM.
# This is to avoid hardcoding the gcc versions for the ROM and kernels.

 TARGET_SM_AND := $(TARGET_GCC_VERSION)
 TARGET_SM_KERNEL := $(TARGET_GCC_VERSION_ARM)

 # Set GCC colors
 export GCC_COLORS := 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

 # Find host os
 UNAME := $(shell uname -s)

 HOST_OS := linux

 TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)/lib
 export TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)/lib

 # Path to ROM toolchain
 SM_AND_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-$(TARGET_SM_AND)
 SM_AND := $(shell $(SM_AND_PATH)/bin/arm-linux-androideabi-gcc --version)

 # Find strings in version info
 SM_AND_NAME := $(filter %sabermod,$(SM_AND))
 SM_AND_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_AND))
 SM_AND_STATUS := $(filter (release) (prerelease) (experimental),$(SM_AND))
 SM_AND_VERSION := $(SM_AND_NAME)-$(SM_AND_DATE)-$(SM_AND_STATUS)

 # Write version info to build.prop
 ifeq (5.1,$(TARGET_GCC_VERSION))
ADDITIONAL_BUILD_PROPERTIES += \
     ro.sm.android=$(SM_AND_NAME)-$(SM_AND_DATE)-(experimental)
 else
ADDITIONAL_BUILD_PROPERTIES += \
     ro.sm.android=$(SM_AND_VERSION)
 endif

 # Path to kernel toolchain
 SM_KERNEL_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/linux-x86/arm/arm-eabi-$(TARGET_SM_KERNEL)
 SM_KERNEL := $(shell $(SM_KERNEL_PATH)/bin/arm-eabi-gcc --version)

 SM_KERNEL_NAME := $(filter %sabermod,$(SM_KERNEL))
 SM_KERNEL_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_KERNEL))
 SM_KERNEL_STATUS := $(filter (release) (prerelease) (experimental),$(SM_KERNEL))
 SM_KERNEL_VERSION := $(SM_KERNEL_NAME)-$(SM_KERNEL_DATE)-$(SM_KERNEL_STATUS)

 # Write version info to build.prop
 ifeq (5.1,$(TARGET_GCC_VERSION_ARM))
ADDITIONAL_BUILD_PROPERTIES += \
     ro.sm.kernel=$(SM_KERNEL_NAME)-$(SM_KERNEL_DATE)-(experimental)
 else
ADDITIONAL_BUILD_PROPERTIES += \
     ro.sm.kernel=$(SM_KERNEL_VERSION)
 endif

 # Add extra libs for the compilers to use
 export LD_LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LD_LIBRARY_PATH)
 export LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LIBRARY_PATH)


ifeq ($(USE_O3_OPTIMIZATIONS),true)
OPT1 := (O3)
 else
   OPT1:=
endif

ifeq ($(STRICT_ALIASING),true)
   OPT2 := (strict)
 else
   OPT2:=
endif

ifeq ($(GRAPHITE_OPTS),true)
OPT3 := (graphite)
 else
   OPT3:=
endif

ifeq ($(KRAIT_TUNINGS),true)
OPT4 := (krait)
 else
   OPT4:=
endif

ifeq ($(ENABLE_GCCONLY),true)
OPT5 := (gcconly)
 else
   OPT5:=
endif

ifeq ($(FLOOP_NEST_OPTIMIZE),true)
OPT6 := (floop_nest_optimize)
 else
   OPT6:=
endif

ifeq ($(TARGET_USE_PIPE),true)
OPT7 := (pipe)
 else
   OPT7:=
endif

ifeq ($(FFAST_MATH),true)
OPT8 := (fast_math)
 else
   OPT8:=
endif

  GCC_OPTIMIZATION_LEVELS := $(OPT1)$(OPT2)$(OPT3)$(OPT4)$(OPT5)$(OPT6)$(OPT7)$(OPT8)
  ifneq ($(GCC_OPTIMIZATION_LEVELS),)
ADDITIONAL_BUILD_PROPERTIES += \
      ro.sm.flags=$(GCC_OPTIMIZATION_LEVELS)
  endif