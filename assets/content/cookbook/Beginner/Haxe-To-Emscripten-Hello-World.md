[tags]: / "Haxe, Emscripten"
# Haxe to Emscripten

This is a hello world example which will be comiled and linked to [Emscripten](https://emscripten.org/).

## Procedure

For this to work in my case. It needs both copies of emsdk-1.35.0-full-64bit.msi and emsdk.zip 64bit version.

## Setup

* **OS** Windows 7 x64 (I have not tested on Mac or Linux).  
* **Haxe** version 4+
* **Emscripten** [V1.35 and emsdk lastest version](https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-1.35.0-full-64bit.exe)

## Implementation

1. Install emsdk-1.35.0-full-64bit.msi (Don't update or install latest version).  
2. Install [emsdk.zip](https://emscripten.org/docs/getting_started/downloads.html).  
3. Update it to latest version and activate it to the latest version.  
   
Create a simple Hello World Haxe code:
   
__Main.hx__

```haxe
package;

@:buildXml("
  <linker id='exe' exe='em++'>
    <flag value='-s' />
    <flag value='WASM=1' />
  </linker>
")

class Main {
  static function main(){
    trace("Haxe is great!");
  }
}
```
    
__build.hxml__
```build
# Windows maybe needs this define
# -D EMSCRIPTEN_SDK

# If you want the .html file showing how to embed the wasm
-D HXCPP_LINK_EMSCRIPTEN_EXT=.html

# Tell hxcpp to use emscripten-toolchain.xml
-D emscripten

-cpp out
-main Main
```
> The link and build.hxml is based on <https://groups.google.com/forum/#!topic/haxelang/Pcm38LPFjW0>  

Comment out `-D EMSCRIPTEN_SDK` (this made it work in my case).  
It will then link "main.html".

Open main.html in your browser to run it.

> Author: [Fhalo](https://github.com/Fhalo48)
