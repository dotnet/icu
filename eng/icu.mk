TOP = $(CURDIR)/../
ICU_FILTER_PATH=$(abspath $(TOP)/icu-filters)

TARGET_OS ?= browser
TARGET_ARCHITECTURE ?= wasm

HOST_OBJDIR = $(TOP)/artifacts/obj/icu-host
TARGET_BINDIR = $(TOP)/artifacts/bin/icu-$(TARGET_OS)-$(TARGET_ARCHITECTURE)
TARGET_OBJDIR = $(TOP)/artifacts/obj/icu-$(TARGET_OS)-$(TARGET_ARCHITECTURE)

# Disable some features we don't need, see icu/icu4c/source/common/unicode/uconfig.h
# TODO: try adding -DUCONFIG_NO_LEGACY_CONVERSION=1
ICU_DEFINES = \
	-DUCONFIG_NO_FILTERED_BREAK_ITERATION=1 \
	-DUCONFIG_NO_REGULAR_EXPRESSIONS=1 \
	-DUCONFIG_NO_TRANSLITERATION=1 \
	-DUCONFIG_NO_FILE_IO=1 \
	-DU_CHARSET_IS_UTF8=1 \
	-DU_CHECK_DYLOAD=0 \
	-DU_ENABLE_DYLOAD=0

CONFIGURE_ARGS = \
	--enable-static \
	--disable-shared \
	--disable-tests \
	--disable-extras \
	--disable-samples \
	--disable-icuio \
	--disable-renaming \
	--disable-icu-config \
	--disable-layout \
	--disable-layoutex \
	--disable-tools \
	--with-cross-build=$(HOST_OBJDIR) \
	--with-data-packaging=archive \

ifeq ($(ICU_TRACING),true)
	CONFIGURE_ARGS += --enable-tracing
endif

# include the OS specific configs
include icu.$(TARGET_OS).mk

# Host build
$(HOST_OBJDIR) $(TARGET_BINDIR) $(TARGET_OBJDIR):
	mkdir -p $@

$(HOST_OBJDIR)/.stamp-host: $(HOST_OBJDIR)/.stamp-configure-host
	cd $(HOST_OBJDIR) && $(MAKE) -j8 all
	touch $@

$(HOST_OBJDIR)/.stamp-configure-host: | $(HOST_OBJDIR)
	cd $(HOST_OBJDIR) && $(TOP)/icu/icu4c/source/configure \
	--disable-icu-config --disable-extras --disable-tests --disable-samples
	touch $@


# Target build

# Parameters:
#  $(1): filter file name (without .json suffix)
define TargetBuildTemplate

$(TARGET_OBJDIR)/$(1):
	mkdir -p $$@

# Run the configure script
$(TARGET_OBJDIR)/$(1)/.stamp-configure: $(ICU_FILTER_PATH)/$(1).json $(HOST_OBJDIR)/.stamp-host | $(TARGET_OBJDIR)/$(1) check-env
	rm -rf $(TARGET_OBJDIR)/$(1)/data/out/tmp
	$(ENV_INIT_SCRIPT) cd $(TARGET_OBJDIR)/$(1) && \
	ICU_DATA_FILTER_FILE=$(ICU_FILTER_PATH)/$(1).json \
	$(ENV_CONFIGURE_WRAPPER) $(TOP)/icu/icu4c/source/configure \
	--prefix=$(TARGET_OBJDIR)/$(1)/install \
	$(CONFIGURE_ARGS) \
	$(CONFIGURE_COMPILER_FLAGS)
	touch $$@

# run source build and copy outputs to bin dir
lib-$(1): data-$(1)
	cd $(TARGET_OBJDIR)/$(1) && $(MAKE) -j8 all && $(MAKE) install
	rm -rf $(TARGET_BINDIR)/lib
	rm -rf $(TARGET_BINDIR)/include
	cp -R $(TARGET_OBJDIR)/$(1)/install/lib $(TARGET_BINDIR)/lib
	cp -R $(TARGET_OBJDIR)/$(1)/install/include $(TARGET_BINDIR)/include

# run data build and copy data file to bin dir
data-$(1): $(TARGET_OBJDIR)/$(1)/.stamp-configure | $(TARGET_OBJDIR)/$(1) $(TARGET_BINDIR)
	cd $(TARGET_OBJDIR)/$(1) && $(MAKE) -C data all && $(MAKE) -C data install
	cp $(TARGET_OBJDIR)/$(1)/data/out/icudt*.dat $(TARGET_BINDIR)/$(1).dat

endef

$(eval $(call TargetBuildTemplate,icudt))
$(eval $(call TargetBuildTemplate,icudt_CJK))
$(eval $(call TargetBuildTemplate,icudt_no_CJK))
$(eval $(call TargetBuildTemplate,icudt_EFIGS))
$(eval $(call TargetBuildTemplate,icudt_normalization))
$(eval $(call TargetBuildTemplate,icudt_base))
$(eval $(call TargetBuildTemplate,icudt_efigsonly))
$(eval $(call TargetBuildTemplate,icudt_currency))
$(eval $(call TargetBuildTemplate,icudt_coll))
$(eval $(call TargetBuildTemplate,icudt_en))
$(eval $(call TargetBuildTemplate,icudt_zh_base))
$(eval $(call TargetBuildTemplate,icudt_en_base))
$(eval $(call TargetBuildTemplate,icudt_cjk_base))
$(eval $(call TargetBuildTemplate,icudt_efigs_base))
$(eval $(call TargetBuildTemplate,icudt_no_cjk_base))
$(eval $(call TargetBuildTemplate,icudt_zones))
$(eval $(call TargetBuildTemplate,icudt_en_zones))
$(eval $(call TargetBuildTemplate,icudt_cjk_zones))
$(eval $(call TargetBuildTemplate,icudt_efigs_zones))
$(eval $(call TargetBuildTemplate,icudt_zh_zones))
$(eval $(call TargetBuildTemplate,icudt_zh))
$(eval $(call TargetBuildTemplate,icudt_cjkonly))
$(eval $(call TargetBuildTemplate,icudt_no_cjkonly))
$(eval $(call TargetBuildTemplate,icudt_locales))
$(eval $(call TargetBuildTemplate,icudt_efigs_coll))
$(eval $(call TargetBuildTemplate,icudt_cjk_coll))

ICU_SHARDS := icudt_base icudt_normalization icudt_currency icudt_coll icudt_zh_base icudt_en_base icudt_cjk_base icudt_no_cjk_base icudt_efigs_base icudt_zones icudt_en_zones icudt_cjk_zones icudt_efigs_zones icudt_en icudt_efigsonly icudt_zh icudt_cjkonly icudt_no_cjkonly icudt_locales icudt_efigs_coll icudt_cjk_coll
DATA_SHARDS := $(addprefix data-, $(ICU_SHARDS))

# build source+data for the main "icudt" filter and only data for the other filters
all: lib-icudt data-icudt data-icudt_no_CJK data-icudt_EFIGS data-icudt_CJK

get_sizes = du -k /Users/tammyqiu/icu/eng/..//artifacts/bin/icu-browser-wasm/$(shard).dat; \
						brotli /Users/tammyqiu/icu/eng/..//artifacts/bin/icu-browser-wasm/$(shard).dat; \
						du -k /Users/tammyqiu/icu/eng/..//artifacts/bin/icu-browser-wasm/$(shard).dat.br; \
						cp /Users/tammyqiu/icu/eng/..//artifacts/bin/icu-browser-wasm/$(shard).dat /Users/tammyqiu/runtime2/artifacts/bin/native/net6.0-Browser-Debug-wasm/;

locale_dictionary.json:
	cd $(TOP)/icu/icu4c/source/ && PYTHONPATH=python python3 -m icutools.databuilder --mode=makedict --filter_file=$(ICU_FILTER_PATH)/icudt.json \
	&& cp locale_dictionary.json /Users/tammyqiu/runtime2/artifacts/bin/native/net6.0-Browser-Debug-wasm/

shards: $(DATA_SHARDS) locale_dictionary.json
	rm /Users/tammyqiu/icu/eng/..//artifacts/bin/icu-browser-wasm/*.br
	$(foreach shard, $(ICU_SHARDS), $(get_sizes))
