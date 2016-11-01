[tags]: / "static-extension,modules"

# Using static extensions

The concept of [static extensions](http://haxe.org/manual/lf-static-extension.html) is a very poweful concept that gives the possibility of keeping types and objects lightweight, and extending them with functionality only when actually needed.
Here we will have a look at how some commonly used methods for basic types are implemented as extension methods, and how you can write your own.

## Where is string replace?

All programming languages that have a `String` type also have something like a `.replace(searchFor:String, replaceWith:String)` method.
Therefore, it might come as a surprise that you can't do the following in Haxe:
```haxe
var s = 'ABxD';
var corr = s.replace('x', 'C'); // Causes an 'String has no field replace' compilation error
```
Instead, the string replace method lives as a static method in a class called **[StringTools](http://api.haxe.org/StringTools.html)**. It can be used like this:
```haxe
var str = 'ABxD';
var corr = StringTools.replace(str, 'x', 'C');
trace(corr); // ABCD
```
The first parameter passed to the replace method is the string to be acted upon. This works, but it's **not** how we want to write our code. 

## Keyword 'using'

To our rescue, we can use the methods of `StringTools` as [static extensions](http://haxe.org/manual/lf-static-extension.html) by
adding `using StringTools;` to the top of our [module](http://haxe.org/manual/type-system-modules-and-paths.html) (typically below the import statements):
```haxe
// We add StringTools as a static extension with the keyword 'using',
// typically below the module imports:
using StringTools; 

class Main {
  static public function main() {
    var str = 'ABxD';
    var corr = str.replace('x', 'C'); // now, our string is "extended" with the replace method!
    trace(corr); // ABCD
  }
}
```
The example above compiles because the `using StringTools;` statement "extends" the functionality of the string variables with the `replace()` method.
(You get other methods as well: `trim()`, `escape()` and `encode()` methods among others.)

The extension methods don't just work on *variables*, they can be used directly on *values* as well:
```haxe
using StringTools; 

class Main {
  static public function main() {
    var corr = 'ABxD'.replace('x', 'C'); // replace method used directly on the string!
  }
}
```


Another example: The `Float` type doesn't have a round method:
```haxe
var f = 0.9;
trace(f.round()); // Causes a 'Float has no field round' compile error
```
Instead it lives in the **[Math](http://api.haxe.org/Math.html)** class (together with `abs()`, `floor()` and other useful methods), so we add it to the module as an static extension:
```haxe
using Math; // Adding 'Math' as a static extension

class Main {
  static function main() {
    var f = 0.9;
    trace(f.round()); // Works, because the float variable is "extended" with the round method!
  }
}
```
Another class often used for static extension is the **[Lambda](http://api.haxe.org/Lambda.html)**, wich extends iterable types (arrays and lists) with functional methods.

## Writing your own static extensions

This concept of extending the functionality of Haxe types and objects using static extensions is very powerful. 
It makes it very easy to create your own reusable libraries with the extensions that you need for the data that you use.

Let's say that you need the possibility to round a float to two decimals. To make this work as a static extension, we start by creating
a `FloatTools` class, and adding a `static public function` with the name `round2` to it:
```haxe
class FloatTools {
  static public function round2(f:Float) {
    // The value 100 rounds to two decimals
    return Math.round(f * 100) / 100;        
  }
}
```
Note that the rounding method takes one parameter of the type float: `round2(f:Float)` - this is of course the value that we want back in rounded form.

We can of course use this new method in the following way:
```haxe
var f = 0.119999;
var rf = FloatTools.round2(f); // 0.12
```
The static extension brings the functionality directly to any float type value or variable in the current module:

```haxe
using FloatTools; // Adding 'FloatTools' as a static extension

class Main {
  static function main() {
    var f = 0.119999;
    var rf = f.round2(); // 0.12
    
    // Please note that the following also works, using the extension method on the value itself
    var rf = 0.119999.round2(); // 0.12
  }
}
```
### Compiler replaces first parameter

As you can see in the example above, we just skip the first parameter to the `round2(f:Float)` method - the compiler takes care of replacing the first parameter with the value that we are acting upon.

### Caveat regarding static extensions in modules

Let's say that we have a file called Main.hx with a class called `Main`. This means that the module is referred to as `Main`, and that
any other class(es) defined in the same class are referred to as `Main.Foo`, `Main.Bar` etc.
[Here's a Try Haxe example](http://try.haxe.org/#720E5) where the FloatTools class has to be referred to as `Test.FloatTools`
because the module name is `Test` (which means that the filename in this case is Test.hx).



> Learn about Haxe Static Extensions here: <http://haxe.org/manual/lf-static-extension.html>
> 
> Author: [Jonas Nyström](https://github.com/cambiata)
