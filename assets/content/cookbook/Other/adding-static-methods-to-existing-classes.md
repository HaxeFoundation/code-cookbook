[tags]: / "static-extension"

# Adding static methods to existing classes

Haxe allows you to add static methods to existing classes (eg. `Math`) via the static extensions feature. The "secret sauce" is to specify the first parameter of the extension as `Class<X>` where `X` is the class you want to add static methods to (eg. `Math`), and to make the method public.

Here's a class with a static method that adds a `randomBetween(a, b)` method to `Math`:

## Implementation

```haxe
class MathExtensions {
  /** Returns a random number between a (inclusive) and b (exclusive). */
  public static function randomBetween(clazz:Class<Math>, a:Int, b:Int) {
    var diff:Int = b - a;
    return a + Math.floor(Math.random() * diff);
  }
}
```

Note that the method is `public`, `static`, and the first parameter is `Class<Math>`.

## Usage

Here's how to consume the code:

```haxe
using MathExtensions;

class Test {
  static function main() {
    trace("Random value between 10 and 20:" + Math.randomBetween(10, 20));
  }
}

```

Using this, you can add all kinds of interesting extensions to pre-existing classes (eg. core Haxe classes, or classes from other Haxe libraries). 

> More on this topic: <http://haxe.org/manual/lf-static-extension.html>
> 
> Author: [ashes999](https://github.com/ashes999)
