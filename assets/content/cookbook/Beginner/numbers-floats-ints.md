[tags]: / "math"

# Using numbers

Define integers and floats:
```haxe
var a:Float = 34;  // Float
var b:Int = 34;    // Int
var c = 34.00;     // Float
var d = 34;        // Int
```

Calculating numbers using [arithmetic operators](https://haxe.org/manual/types-numeric-operators.html):
```haxe
var a = 10;
var b = 20;
var c = (a + (2 * b)) / 5;
trace(c); // 10 (Float)
```

Haxe interprets numeric constants as hexadecimal if they are preceded by `0x`:
```haxe
var value = 0xFF; // 255 (Int)
```

Extra large or small numbers can be written with scientific exponent notation:
```haxe
var x = 123e5;    // 12300000
var y = 123e-5;   // 0.00123
```

Floating point arithmetic is not always 100% accurate
```haxe
var value = 0.1 + 0.2; // 0.30000000000000004
```

Creating random numbers:
```haxe
Std.random(10); // a random Int between 0 (included) and 10 (excluded)
Math.random();  // a random Float between 0.0 (included) and 1.0 (excluded)
```

Defines infinity. Value equals [infinity](http://api.haxe.org/Math.html#POSITIVE_INFINITY):
```haxe
var value = 1 / 0; // infinity

trace((1 / 0) == Math.POSITIVE_INFINITY);  // true
trace((-1 / 0) == Math.NEGATIVE_INFINITY); // true
```

Defines and check to [NaN](http://api.haxe.org/Math.html#NaN) (Not A Number). 
```haxe
var value = Math.sqrt(-1); // NaN
trace(Math.isNaN(value));  // true
```

## Parsing numbers

Parsing [String to Int](http://api.haxe.org/Std.html#parseInt):
```haxe
Std.parseInt("3"); // 3
Std.parseInt("3.5"); // 3
Std.parseInt("3 kilo"); // 3
Std.parseInt("kilo: 3.5"); // null
```

Parsing [String to Float](http://api.haxe.org/Std.html#parseFloat):
```haxe
Std.parseFloat("3"); // 3.0
Std.parseFloat("3.5"); // 3.5
Std.parseFloat("3.5 kilo"); // 3.5
Std.parseFloat("kilo: 3.5"); // Math.NaN
```

Convert [Float to Int](http://api.haxe.org/Std.html#int):
```haxe
var value:Float = 3.3;
Std.int(value); // 3
Math.floor(value); // 3
Math.round(value); // 3
Math.ceil(value); // 4
```

Convert [numbers to string](http://api.haxe.org/Std.html#string):
```haxe
var myInt = 10;
var myFloat = 10.5;
Std.string(myInt); // "10"
Std.string(myFloat); // "10.5"
```
## Math

Calculating degrees to radians and radians to degrees:
```haxe
var radians = Math.PI * 2;
var degrees = radians * 180 / Math.PI;
var radians =  degrees * Math.PI / 180;
```

Using sinus and cosinus to set the position at a distance from the given angle:
```haxe
var angle = Math.PI;
var distance = 100;
var x = Math.cos(angle) * distance;
var y = Math.sin(angle) * distance;
```

Calculating the angle of two points:
```haxe
var point1 = {x: 350, y: 0}
var point2 = {x: 350, y: 150}

var dx = point2.x - point1.x;
var dy = point2.y - point1.y;
var angle = Math.atan2(dy, dx);
trace(angle); // PI/2
```

> **API documentation**
> 
> * [Int](http://api.haxe.org/Int.html) and [Float](http://api.haxe.org/Float.html) API documentation
> * [Math](http://api.haxe.org/Math.html) API documentation
>
> **Manual**
> 
> * [Basic types in Haxe](https://haxe.org/manual/types-basic-types.html)
> * [Math in Standard Library](http://haxe.org/manual/std-math.html)
> * [Arithmetic operators](https://haxe.org/manual/types-numeric-operators.html)
