[tags]: / "abstract-type,math"

# Rounded Float 

This [abstract type](http://haxe.org/manual/types-abstract.html) is based on the underlying `Float` type, but
whenever it is converted back to an actual `Float` it is rounded to avoid the famous [rounding errors](https://en.wikipedia.org/wiki/Round-off_error)
occuring in floating point aritmetics.

**Please note** that this example doesn't solve the rounding error problem - it just covers it by rounding the errors away.
This shouldn't be used in situations where accumulated errors might cause critical problems - for example in financial calculations.
For those cases, something like Franco Ponticelli's [thx.Decimal](https://github.com/fponticelli/thx.core/blob/master/src/thx/Decimal.hx) should be used instead.

```haxe
abstract RFloat(Float) from Float {
  inline function new(value : Float)  
    this = value;
  
  // The following rounds the result whenever converted to a Float
  @:to inline public function toFloat():Float 
    return roundPrecision(this);
   
  @:to inline public function toString():String
    return Std.string(toFloat());

  // The number of zeros in the following valuer
  // corresponds to the number of decimals rounding precision
  static inline var multiplier = 10000000;
    
  static inline function roundPrecision(value:Float):Float
    return Math.round(value * multiplier) / multiplier;
}
```

## Usage

```haxe
// Standard float gives a result with rounding error
var f:Float = 2.0 - 1.1;
trace(f); // 0.8999999999999999

// RFloat abstract rounds the error away
var rf:RFloat = 2.0 - 1.1;
trace(rf); // 0.9
```

> Learn about Haxe Abstracts here: <http://haxe.org/manual/types-abstract.html>
> 
> Author: [Jonas Nyström](https://github.com/cambiata)

