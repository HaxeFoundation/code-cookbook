[tags]: / "cpp,compiler"

# Compiling c++ code on Windows using mingw

On windows, the compiler by default expects an installation of Microsoft Visual Studio Community edition when targeting c++. 

However, there's the possibility of using [mingw](http://www.mingw.org/) instead, wich is much more quick and lightweight when it comes to installation size and hazzle. 

> Please keep in mind that mingw isn't the default compiler alternative, and that you might need to dive into the cold c++ sea to get other than basic stuff going. 

Setup and usage is very easy:

## Installing mingw using haxelib

The mingw compiler can be installed using haxelib with the following command:

`> haxelib install minimingw`

This downloads the mingw compiler into the location where the hxcpp toolchain expects to find ite.

## Add `-D toolchain=mingw` compiler directive

You also have to add the `-D toolchain=mingw` to your project's .hxml file. Here's an example of how a .hxml-file might look:

```
# build.hxml example using mingw c++ compiler
-cp src
-main Main
-D toolchain=mingw
-cpp bin-mingw
```

That's it!

> Author: [Jonas Nyström](https://github.com/cambiata)



