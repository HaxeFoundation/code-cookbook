[tags]: / "cppia"

# Creating a cppia host

## What is cppia?

**Cppia** is a scriptable "cpp subtarget" for [Haxe](http://haxe.org), created by [Hugh Sanderson](https://twitter.com/GameHaxe).
Information about cppia can be found in Hugh's [WWX2015 talk](https://www.youtube.com/watch?v=hltXpZ3Upxg) (cppia part starts around 15:45).

A **cppia script** is a "instructions assembly" script that can be run by inside a **cppia host**, and gives you Neko JIT runtime speed at near-zero compilation time. It also lets add performance critical code to the host, wich gives you full cpp runtime speed for those parts.

## Creating a cppia host

Please [have a look here](/category/cppia-\(scriptable-Cpp\)) for information about how to create the **script.cppia** file needed in this example.

A cppia host is a c++ executable compiled with the Haxe c++ target. To create a host, we start with a class file (here we choose the name Host.hx) including a **static main** function:

```haxe
// Host.hx
class Host {
  static public function main():Void {
    trace('Hello from cppia HOST');
    var scriptname = './script.cppia';             
    cpp.cppia.Host.runFile(scriptname);  // <- load and execute the .cppia script file 
  }
}
```

As you can see in the code example above, at runtime our executable will start by tracing a simple "Hello from cppia HOST" message.
Then it will load and execute the **script.cppia** file.

## host.hxml

We can compile this file into a cpp executable using the following **host.hxml** file:

```haxe
-cp src
-main Host
-cpp bin
-D scriptable
```

(Please note that we use the **-D scriptable** directive to tell the compiler to include the functionality needed by a cppia host.)

When we run the following command...

```haxe
> haxe host.hxml
```

...the c++ compiler will start the two step compilation process (1. generate the c++ source files, and 2. kick off the c++ compiler to create the executable).
The result will be a host executable called **bin/Host** on Linux/Mac and **bin/Host.exe** on Windows.

## Testing the cppia host executable

Navigate to the **/bin** folder and start the application from the terminal. 
On Windows, typically run `Host.exe`, and on Linux/Mac run `./Host`.

This should start the application, and the following should be written to the terminal:

```haxe
> Host.hx:4: Hello from Cppia Host
> Script.hx:4: Hello from Cppia SCRIPT
```

This indicates that the host has run (traced its own message) and executed the script (traced the script message).

If you get the following message...

```haxe
> Error: [file_contents,./script.cppia]
```
...the host can't find the script file. Make sure that you have followed the **Creating a cppia script** tutorial, and that the **script.cppia** is placed in the same folder as your Host executable. 

> Author: [Jonas Nyström](https://github.com/cambiata)
