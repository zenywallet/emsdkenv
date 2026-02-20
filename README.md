# emsdkenv
A Emscripten SDK environment selector

## Install
    git clone https://github.com/zenywallet/emsdkenv
    cd emsdkenv
    nimble install --verbose

## Update
    git pull
    nimble uninstall emsdkenv --inclDeps --verbose; nimble install --verbose

## Uninstall
    nimble uninstall emsdkenv --inclDeps --verbose
    rm -rf ~/.emsdkenv

## Usage
```nim
proc emsdkEnv(cmd: string, ver: string = "latest")
```

```nim
import emsdkenv

emsdkEnv("nim c -d:emscripten --noMain:on -o:newcomer.js newcomer.nim")
emsdkEnv("nim c -d:emscripten --noMain:on -o:legacy.js legacy.nim", "3.1.65")
emsdkEnv("emconfigure ./configure")
emsdkEnv("emmake make")
```

## Command Line
```shell
emsdkenv 3.1.65
emcc -v
```
Press Ctrl+D to exit the emsdkenv shell.

## License
MIT
