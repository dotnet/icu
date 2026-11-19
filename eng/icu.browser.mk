ENV_INIT_SCRIPT = source $(EMSDK_PATH)/emsdk_env.sh &&
ENV_CONFIGURE_WRAPPER = emconfigure

ifeq ($(WASM_ENABLE_THREADS),true)
	THREADS_FLAG="-pthread"
endif

ifeq ($(TARGET_ARCHITECTURE),wasm64)
	MEMORY64_FLAG = -m64
	CONFIGURE_COMPILER_FLAGS += LDFLAGS="$(MEMORY64_FLAG)"
	# The .NET SDK cache does not include memory64 system libraries.
	export FROZEN_CACHE :=
endif

CONFIGURE_COMPILER_FLAGS += \
	CFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(THREADS_FLAG) $(ICU_DEFINES)$(if $(MEMORY64_FLAG), $(MEMORY64_FLAG))" \
	CXXFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(THREADS_FLAG) $(ICU_DEFINES)$(if $(MEMORY64_FLAG), $(MEMORY64_FLAG))"

check-env:
	@if [ -z "$(EMSDK_PATH)" ]; then echo "The EMSDK_PATH environment variable needs to set to the location of the emscripten SDK."; exit 1; fi
ifeq ($(TARGET_ARCHITECTURE),wasm64)
	$(ENV_INIT_SCRIPT) emcc --version
endif

