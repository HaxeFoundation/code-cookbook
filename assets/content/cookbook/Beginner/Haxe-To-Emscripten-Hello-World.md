[tags]: / "Haxe, Emscripten"
# Haxe to Emscripten
This is a hello world example which will be comiled and linked to [Emscripten](https://emscripten.org/).

## Procedure
For this to work in my case. It needs both copies of emsdk-1.35.0-full-64bit.msi and emsdk.zip 64bit version.

## Existing Setup
  OS: Windows 7 x64 (Have not tested on Mac or Linux).  
  
  Haxe: V4.x.  

  Emscripten: [V1.35 and emsdk lastest version](https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-1.35.0-full-64bit.exe)

## Possible Solution
   Install emsdk-1.35.0-full-64bit.msi (Do not update it or install latest version).  

   Install [emsdk.zip](https://emscripten.org/docs/getting_started/downloads.html).  
   
   Update it to latest version and activate it to the latest version.  
   
   Create a simple Hello world Haxe code.
   
   Main.hx
   
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
         trace("Hello Wolrd CPP");
         }
      }
    ```
    
   build.hxml
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
   The Link and build.hxml from cames from  <https://groups.google.com/forum/#!topic/haxelang/Pcm38LPFjW0>  
   
   Comment out -D EMSCRIPTEN_SDK (for it to work in my case).  
   
   It will then link "Main.html".
   
   "Open Main.html in your browser to run it."
 


> Author: [Fhalo](https://github.com/Fhalo48)
