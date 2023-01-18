ifeq ($(WASM_ENABLE_THREADS),true)
	THREADS_FLAG="-pthread"
endif

CONFIGURE_COMPILER_FLAGS += \
        CFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(THREADS_FLAG) $(ICU_DEFINES)" \
        CXXFLAGS="-Oz -fno-exceptions -Wno-sign-compare $(THREADS_FLAG) $(ICU_DEFINES)" \
        CC="$(WASI_SDK_PATH)/bin/clang --sysroot=$(WASI_SDK_PATH)/share/wasi-sysroot" \
        --host= x86_64-pc-linux-gnu --build=wasm32
check-env:
  :