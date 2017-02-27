[tags]: / "javascript,dead-code-elimination,libraries"

# Using Haxe classes in JavaScript

Normally, when compiling Haxe to JavaScript, the resulting code is kept away from the global scope. This means that you can't reach the Haxe generated code from other scripts. 
To make that possible, there's the `@:expose` metadata that can be used on a class. This makes the class "exposed" to the global scope, and therefore possible to use in plain JavaScript.

> Haxe can compile to many targets, this example is specific for the Haxe/JavaScript target only.

Here's an example of a simple utility class, where we use the `@:expose` metadata. To make sure that the class isn't accidentally stripped away by [dead code elimination](http://haxe.org/manual/cr-dce.html), we also add the `@:keep` metadata:
	
```haxe
package foo;

@:expose  // <- makes the class reachable from plain JavaScript
@:keep    // <- avoids accidental removal by dead code elimination
class MyUtils {
  public function new() { }
  public function multiply(a:Float, b:Float) return a * b;
}
```

This class can of course be called from Haxe the standard way:
```haxe
class Main {
  static function main() {
    var utils = new foo.MyUtils();
    trace(utils.multiply(1.1, 3.3));
  }
}
```
...and after compiling it with something like the following **build.hxml**:
```hxml
-cp src
-main Main
-js bin/app.js
-dce full
```
...and run in an **index.html** like the this one:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
</head>
<body>
  <script src="app.js"></script>
</body>
</html>
```
...it traces the multiplied result to the browser console.

However, the MyUtils class is also exposed to the global scope and this makes it possible to use it for example in this way:
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
</head>
<body>
  <script src="app.js"></script>
  <script>
    // Using the Haxe-generated MyUtils class
    // from standard JavaScript
    var utils = new foo.MyUtils();
    console.log(utils.multiply(2.2, 3.3));
  </script>
</body>
</html>
```


> Learn about the use of @:expose metadata here: <http://haxe.org/manual/target-javascript-expose.html>
> 
> Author: [Jonas Nyström](https://github.com/cambiata)


