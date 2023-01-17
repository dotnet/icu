#ENV_INIT_SCRIPT = source $(WASI_SDK_PATH)/share/cmake/wasi-sdk.cmake
# TODO find out if this is needed for wasi-sdk 
# ENV_CONFIGURE_WRAPPER = emconfigure

ifeq ($(WASM_ENABLE_THREADS),true)
	THREADS_FLAG="-pthread"
endif

CONFIGURE_COMPILER_FLAGS += \
	CFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(THREADS_FLAG) $(ICU_DEFINES)" \
	CXXFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(THREADS_FLAG) $(ICU_DEFINES)"

check-env:
:
