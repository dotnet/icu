TVOS_MIN_VERSION=11.0

ifeq ($(TARGET_ARCHITECTURE),x64)
	TVOS_ARCH=x86_64
	TVOS_SDK=appletvsimulator
	TVOS_ICU_HOST=x86_64-apple-darwin
endif
ifeq ($(TARGET_ARCHITECTURE),arm64)
	TVOS_ARCH=arm64
	TVOS_SDK=appletvsimulator
	TVOS_ICU_HOST=aarch64-apple-darwin
endif

XCODE_DEVELOPER := $(shell xcode-select --print-path)
XCODE_SDK := $(shell xcodebuild -version -sdk $(TVOS_SDK) | grep -E '^Path' | sed 's/Path: //')

CONFIGURE_COMPILER_FLAGS += \
	CFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(ICU_DEFINES) -isysroot $(XCODE_SDK) -I$(XCODE_SDK)/usr/include/ -arch $(TVOS_ARCH) -mappletvsimulator-version-min=$(TVOS_MIN_VERSION)" \
	CXXFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(ICU_DEFINES) -isysroot $(XCODE_SDK) -I$(XCODE_SDK)/usr/include/ -I./include/ -arch $(TVOS_ARCH) -mappletvsimulator-version-min=$(TVOS_MIN_VERSION)" \
	LDFLAGS="-L$(XCODE_SDK)/usr/lib/ -isysroot $(XCODE_SDK) -mappletvsimulator-version-min=$(TVOS_MIN_VERSION)" \
	CC="$(XCODE_DEVELOPER)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" \
	CXX="$(XCODE_DEVELOPER)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"

CONFIGURE_ARGS += --host=$(TVOS_ICU_HOST)

check-env:
	:
