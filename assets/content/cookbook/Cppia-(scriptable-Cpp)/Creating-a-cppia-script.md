# Creating a cppia script

## What is cppia?

**Cppia** is a scriptable "cpp subtarget" for [Haxe](http://haxe.org), created by [Hugh Sanderson](https://twitter.com/GameHaxe).
Information about cppia can be found in Hugh's [WWX2015 talk](https://www.youtube.com/watch?v=hltXpZ3Upxg) (cppia part starts around 15:45).

A **cppia script** is a "instructions assembly" script that can be run by inside a **cppia host**, and gives you Neko JIT runtime speed at near-zero compilation time. It also lets add performance critical code to the host, wich gives you full cpp runtime speed for those parts.

## Creating a cppia script

A cppia script is created as any other Haxe program - with a class file (here we choose the name Script.hx) including a **static main** function:

```haxe
// Script.hx
class Script {
  static public function main():Void {
    trace("Hello from Cppia SCRIPT");
  }
}
```

## script.hxml

We can then compile this file into a cppia script using the following **script.hxml** file:

```haxe
-cp src
-main Script
-cppia bin/script.cppia
```

When we run the following command...

```haxe
> haxe script.hxml
```

...a **script.cppia** is created in the bin foloder.

## Testing our cppia script

For testing purposes, the **haxelib hxcpp** installation includes a Cppia host program wich can
be used to test simple scripts.

Navigate to the **/bin** folder, and run the following command:

```haxe
> haxelib run hxcpp script.cppia
```

This should output the following in the console:
```haxe
> Script.hx:4: Hello from Cppia SCRIPT
```

Now, we know that our script works and can be executed by an cppia host.
