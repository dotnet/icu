if [[ "$__TargetOS" == Browser ]]; then
EMSDK_PATH=$PWD/artifacts/emsdk
rm -rf $EMSDK_PATH
git clone https://github.com/emscripten-core/emsdk.git $EMSDK_PATH
EMSCRIPTEN_VERSION="`cat ./.devcontainer/emscripten-version.txt 2>&1`"
cd $EMSDK_PATH && ./emsdk install $EMSCRIPTEN_VERSION
cd $EMSDK_PATH && ./emsdk activate $EMSCRIPTEN_VERSION
# ready to build, e.g.:
# ./build.sh /p:TargetOS=Browser /p:TargetArchitecture=wasm /p:IcuTracing=true
elif [[ "$__TargetOS" == Wasi ]]; then
WASI_SDK_PATH=$PWD/artifacts/wasi-sdk
rm -rf $WASI_SDK_PATH
git clone https://github.com/WebAssembly/wasi-sdk.git $WASI_SDK_PATH
WasiSdkVersion="`cat ./.devcontainer/wasi-sdk-version.txt 2>&1`"
cd $WASI_SDK_PATH && ./wasi-sdk install $WasiSdkVersion
cd $WASI_SDK_PATH && ./wasi-sdk activate $WasiSdkVersion
# ready to build, e.g.:
# ./build.sh /p:TargetOS=Wasi /p:TargetArchitecture=wasm /p:IcuTracing=true
fi