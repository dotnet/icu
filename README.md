# ICU (MS-ICU)

This is a fork of https://github.com/microsoft/icu for enabling dotnet on WebAssembly.

# Build Notes

### Compressed iOS dat files

We are using https://github.com/lzfse/lzfse to compress the dat files. This can be installed via:

`brew install lzfse`

We have not integrated this into the build as we are only shipping prebuilt .dat files in `eng/prebuilts`. To compress a prebuilt, run:

`lzfse -encode -i eng/prebuilts/mobile/icudt.dat -o eng/prebuilts/mobile/icudt.dat.lzfse`