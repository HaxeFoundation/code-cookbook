[tags]: / "Haxe, Emscripten"
# Haxe to Emscripten

This is a hello world example which will be compiled and linked to [Emscripten](https://emscripten.org/).

## Setup

* **OS** Windows 7 x64 (I have not tested on Mac or Linux).  
* **Haxe** version 4+
* **Emscripten** [emsdk lastest version](https://emscripten.org/docs/getting_started/downloads.html)

## Implementation

1. Install [emsdk.zip](https://emscripten.org/docs/getting_started/downloads.html).  
2. Update it to latest version and activate it to the latest version.  
   
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
-D EMSCRIPTEN_SDK

# If you want the .html file showing how to embed the wasm
-D HXCPP_LINK_EMSCRIPTEN_EXT=.html

# Tell hxcpp to use emscripten-toolchain.xml
-D emscripten

-cpp out
-main Main
```
> The link and build.hxml is based on <https://groups.google.com/forum/#!topic/haxelang/Pcm38LPFjW0>  

It will then link "main.html".

Open main.html in your browser to run it.

## Problem
Unable to find the full path for emcc.

## Possible Solution
The problem was traced to the variable EMSCRIPTEN_SDK, in the emscripten-toolchain.xml. Found in the "\HaxeToolkit\haxe\lib\hxcpp\4,0,19\toolchain" folder. When the EMSCRIPTEN_SDK, is set to the correct path for 'emcc'. The script still unable to find the full path to 'emcc'.

The best option is to hard code the full path name in the emscripten-toolchain.

Change from:
```
<section if="windows_host">
   <set name="HXCPP_RANLIB" value='python "${EMSCRIPTEN_SDK}/emranlib"' />
   <set name="HXCPP_AR" value='python "${EMSCRIPTEN_SDK}/emar"' />
   <set name="CXX" value='python "${EMSCRIPTEN_SDK}/emcc"' />
</section>

```
To:
```
<section if="windows_host">
   <set name="HXCPP_RANLIB" value='python "c:\emsdk\fastcomp\emscripten/emranlib"' />
   <set name="HXCPP_AR" value='python "c:\emsdk\fastcomp\emscripten/emar"' />
   <set name="CXX" value='python "c:\emsdk\fastcomp\emscripten/emcc"' />
</section>
```

With the above solution you will only need to install the latest version of emsdk..

> Author: [Fhalo](https://github.com/Fhalo48)
