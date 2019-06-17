[tags]: / "Haxe, Emscripten"
# Haxe to Emscripten
Simple hello world  Haxe code. Then compile and linked to emscrpten.
But, first I would like to thanks everyone from the Haxe community for helping
resolving this.

### Procedure
For some odd reason for this to work. It need both copies of emsdk-1.35.0-full-64bit.msi and emsdk.zip 64bit version.


* OS: Windows 7 x64
* Haxe: V4.x
* Emscripten: V1.35 and emsdk lastest version

  * Install emsdk-1.35.0-full-64bit.msi (Do not update it or install latest version)
  * Install emsdk.zip (https://emscripten.org/docs/getting_started/downloads.html)
  * Update it to latest version and activate it to the latest version
  * Create a simple Hello world Hexe code
   * Main.hx
   
    ```haxe
         package;
         @:buildXml("
         <linker id='exe' exe='em++'>
           <flag value='-s' />
           <flag value='WASM=1' />
         </linker>
         ")

         /**
          * ...
          * @author ds
          */
         class Main 
         {

           static function main() 
           {
              trace("Hello Wolrd CPP");
           }

        }
    ```
    * build.hxml
   ```
       # Windows maybe needs this define
       # -D EMSCRIPTEN_SDK

       # If you want the .html file showing how to embed the wasm
       -D HXCPP_LINK_EMSCRIPTEN_EXT=.html

       # Tell hxcpp to use emscripten-toolchain.xml
       -D emscripten

       -cpp out
       -main Main
    ```
 * The Link and build.hxml came from:- https://groups.google.com/forum/#!topic/haxelang/Pcm38LPFjW0
 * comment out -D EMSCRIPTEN_SDK (for it to work in my case)
 * It will then link Main.html
 * Double click on it Main.html. It will run in the broswer.
 


> Author: [Fhalo](https://github.com/Fhalo48)
