[tags]: / "haxe4,libraries,compiler"

Please note that the file naming method described here requires for **Haxe 4**.

# Writing target-specific modules differentiated by filename

The standard way of naming module files in haxe is `<Modulename>.hx` - the module name spelled with first letter capital, and ending with `.hx` as extension. Let's say we have the following class called `Example`:
```haxe
// Example.hx
class Example {
	public function new() {
		trace('Hello from Example!');
	}
}
```
If we want to write target-specific code, the most common way is using [conditional compilation](https://haxe.org/manual/lf-condition-compilation.html):
```haxe
// Example.hx
class Example {
	public function new() {
        #if (js)
            // when compiled and run for javascript:
		    trace('Hello from JAVASCRIPT-SPECIFIC Example!');
        #else
            // when compiled and run on any other target:
            trace('Hello from Example!');
        #end
	}
}
```

# Using `<Modulename>.<target>.hx` as filename

If using Haxe 4, we can as an alternative put the target specific code in a separate file, using the `<Modulename>.<target>.hx` naming convention.

A javascript-specific file for our `Example` class would then be named `Example.js.hx`:
```haxe
// Example.js.hx <-- Note .js. in the filename!
class Example {
	public function new() {        
		    trace('Hello from JAVASCRIPT-SPECIFIC Example!');
	}
}
```
Whenever compiled for javascript, the compiler first looks for `Example.js.hx` and - if present - uses that. If a target specific file is not found, it looks for `Example.hx`.

Please note that the `<target>` name used should be the [target define](https://haxe.org/manual/lf-target-defines.html) for each target respectively: `js` for javascript, `cpp` for C++, `neko` for Neko target etc.

> See <https://haxe.org/manual/lf-target-specific-files.html>

> Author: [Jonas Nyström](https://github.com/cambiata)