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
WASISDK_PATH=$PWD/artifacts/wasi-sdk
rm -rf $WASISDK_PATH
git clone https://github.com/WebAssembly/wasi-sdk.git $WASISDK_PATH
WASISDK_VERSION="`cat ./.devcontainer/emscripten-version.txt 2>&1`"
cd $WASISDK_PATH && ./wasi-sdk install $WASISDK_VERSION
cd $WASISDK_PATH && ./wasi-sdk activate $WASISDK_VERSION
# ready to build, e.g.:
# ./build.sh /p:TargetOS=Wasi /p:TargetArchitecture=wasm /p:IcuTracing=true
fi