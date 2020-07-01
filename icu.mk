all: icu-wasm

TOP = $(CURDIR)
HOST_BUILDDIR = $(TOP)/artifacts/obj/icu-host
HOST_BINDIR = $(TOP)/artifacts/bin/icu-host
WASM_BUILDDIR = $(TOP)/artifacts/obj/icu-wasm
WASM_BINDIR = $(TOP)/artifacts/bin/icu-wasm

check-env:
	@if [ -z "$(EMSDK_PATH)" ]; then echo "The EMSDK_PATH environment variable needs to set to the location of the emscripten SDK."; exit 1; fi

$(HOST_BUILDDIR):
	mkdir -p $@

.PHONY: host
host: .stamp-host

.stamp-host: $(HOST_BUILDDIR) .stamp-configure-host
	cd $(HOST_BUILDDIR) && $(MAKE) all install
	touch $@

.stamp-configure-host:
	cd $(HOST_BUILDDIR) && $(TOP)/icu4c/source/configure --prefix=$(HOST_BINDIR)
	touch $@

$(WASM_BUILDDIR):
	mkdir -p $@

.PHONY: icu-wasm
icu-wasm: $(WASM_BUILDDIR) .stamp-configure-wasm
	cd $(WASM_BUILDDIR) && $(MAKE) all install

.stamp-configure-wasm: .stamp-host | $(WASM_BUILDDIR) check-env
	cd $(WASM_BUILDDIR) && source $(EMSDK_PATH)/emsdk_env.sh && emconfigure $(TOP)/icu4c/source/configure --prefix=$(WASM_BINDIR) --enable-static --disable-shared CXXFLAGS="-Wno-sign-compare" --with-cross-build=$(HOST_BUILDDIR) --with-data-packaging=archive --disable-extras --disable-renaming
	touch $@
