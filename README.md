# ICU (MS-ICU)

This is a fork of https://github.com/microsoft/icu for enabling dotnet on WebAssembly.

## Browser wasm64

On Linux x64, build single-threaded ICU for Emscripten memory64 with:

```sh
./build.sh --restore --build /p:TargetOS=Browser /p:TargetArchitecture=wasm64
```

The build uses the repository-pinned Emscripten SDK and writes the archives,
headers, filtered data, and `emscripten-version.txt` to
`artifacts/bin/icu-browser-wasm64`. It also checks that all archive members can
be linked as wasm64. The browser wasm32 build remains `TargetArchitecture=wasm`.

The `Microsoft.NETCore.Runtime.ICU.Transport` package provides these assets
under `runtimes/browser-wasm64`, with libraries and data under `native/lib`
and headers under `native/include`. Consumers must link with Emscripten memory64
and must not substitute `browser-wasm` archives. Like browser wasm32, the
package uses the checked-in wasm `.dat` files unless packed with
`/p:OverrideBundledDatFiles=true`. Threaded browser wasm64 and WASI wasm64
are not supported.
