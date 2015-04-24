# Inherit AOSP device configuration for mako
$(call inherit-product, device/moto/shamu/aosp_shamu.mk)

# Inherit common product files
$(call inherit-product, vendor/twisted/configs/common.mk)

# Override AOSP build properties
PRODUCT_NAME := twisted_shamu
PRODUCT_BRAND := Google
PRODUCT_MODEL := Nexus 6
PRODUCT_MANUFACTURER := motorola
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=shamu BUILD_FINGERPRINT="google/shamu/shamu:5.0.1/LMY47V/1602158:user/release-keys" PRIVATE_BUILD_DESC="shamu-user 5.0.1 LMY47v 1602158 release-keys"

