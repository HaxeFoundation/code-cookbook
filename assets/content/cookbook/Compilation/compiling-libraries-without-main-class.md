[tags]: / "libraries,javascript,dead-code-elimination"

# Compiling libraries without main class

In most cases, you want a Main class with a static main function as entry point to start your program. 
However, there are cases where there is no need for this - for example if you are writing a library
that other programs will be using. 

Here's how you can compile your code without having a Main class and a static entry main function:

### Create your library class(es)

Let's create an library class called **BarLib** placed in a **foo** package: 
```haxe
package foo;

class BarLib {
  public function new()  {}

  public function test() {
    return "Hello from BarLib!";
  }
}
```

### Create a build.hxml without -main
Now, we can create a **build.hxml** *without* specifying the Main class `-main Main` the way we usually do. 
Instead we add the classes that we want to include, one per row, using the full class name including package path:

```hxml
-cp src 

# add the class(es) that you want to include the following way, one per line
foo.BarLib    # <- Include the class foo.BarLib

-js bin/lib.js    # <- Compile the library, in this case to JavaScript
```

### Compile the library

Now, you can compile your library with `> haxe build.hxml`.

If you compile to JavaScript, the result will be the following: 
```javascript
(function (console) { "use strict";
var foo_BarLib = function() {
};
foo_BarLib.prototype = {
  test: function() {
    return "Hello from BarLib";
  }
};
})(typeof console != "undefined" ? console : {log:function(){}});
```

You can include more than one package/class if needed in the build.hxml:
```hxml
-cp src 

foo.BarLib    # include class foo.BarLib
buz.qux.Norf  # include class buz.qux.Norf
Config        # include class Config
...

```

### Caution with dead code elimination

[Dead code elimination](http://haxe.org/manual/cr-dce.html) is a great Haxe compiler feature that lets the compiler remove code that isn't used by the program. In this case, when dealing with libraries, this might cause unwanted results: If you compile the examples above with full dead code elimination (using the compilation flag `-dce full`), all your library code will be stripped away! To avoid a class being stripped away like this, use the metadata `@:keep` before the class definition:

```haxe
package foo;

@:keep // <-- Avoid dead code elimination stripping this class away 
class BarLib {
  public function new()  {}

  public function test() {
    return "Hello from BarLib!";
  }
}
```
**Note:** This works (as you would expect) the same for all Haxe targets.

### Exposing Haxe classes for JavaScript

If you are writing libraries for JavaScript, you might want to use the `@:expose` metadata to make your code available in the global namespace. You can [read more about that in the Haxe manual](http://haxe.org/manual/target-javascript-expose.html) or in [this snippet](category/other/using-haxe-classes-in-javascript.html).

> Author: [Jonas Nyström](https://github.com/cambiata)
