[tags]: / "libraries,javascript"

# Compiling libraries without main class

In most cases, you want a Main class with a static main function as entry point to start your program. 
However, there are cases where there is no need for this - for example if you are writing a library
that other programs will be using. 

Here's how you can compile your code without having a Main class and a static entry main function:

### Create your library class(es)

Let's create an library class called **BarLib** placed in a **foo** package: 
```haxe
// foo.BarLib.hx

package foo;

class BarLib {
  public function new()  {}

  public function test() {
    return 'Hello from BarLib!';
  }
}
```

### Create a build.hxml with --macro include
Now, we can create a **build.hxml** *without* specifying the Main class `-main Main` the way we usually do. 
Instead we use `--macro "include('package.path.to.lib.classes')"` to include the packages we want:

```haxe
// build.hxml

-cp src 

# add the package(s) that you want to include the following way: 
--macro "include('foo')"    # <- Include all classes in the 'foo' package

-js bin/lib.js    # <- Compile library, in this case to javascript

```

You can include more than one package if needed:
```haxe
--macro "include('foo')"    # <- Include all classes in the 'foo' package
--macro "include('bar.buz')"    # <- Include all classes in the 'bar.buz' package
```

### Compile

Now, you can compile your library with `> haxe build.hxml`.

If you compile to javascript, the result will be the following: 
```javascript
// bin/lib.js
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

### Exposing Haxe classes for JavaScript

If you are writing libraries for javascript, you might want to use the `@:expose` metadata to make your code available in the global namespace. You can [read more about that in the Haxe manual](http://code.haxe.org/category/beginner/using-static-extensions.html).

> Author: [Jonas Nyström](https://github.com/cambiata)
