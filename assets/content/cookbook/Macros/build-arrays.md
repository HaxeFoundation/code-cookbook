[tags]: / "build-function,building-fields,array"

# Generating Arrays with values

Sometimes it is useful make your arrays compile-time, for example to embed data from files, to pre-calculate heavy calculations, generating lookup tables and other similar things. 
With macros this is perfectly doable but requires some basic knowledge of expression building. 
In this article you will find out how to build arrays and return them as expressions in a macro function.

## Introduction

Before we dive into macros, its good to first start with creating a normal function that illustrates what we expect our function to do.
Take a look at this Test class. It has a function `getFloats()` which returns an array of ten float values. Note that the `points` array variable we create here can be any array and just serves as example.

The return type of this `getFloats` function is `Array<Float>`. You can keep it blank to leave it up to the compiler.

```haxe
class Test {
  public static function getFloats() {
    // make array with floats
    var points:Array<Float> = [for (value in 0...10) value];
    return points;
  }
}
```

Its usage is very convenient:
```haxe
var myArray:Array<Float> = Test.getFloats();
```
The generated code will also look like that; this `getFloats()` function is created when you execute it (runtime). 

Now given we want to use macros we basically want Haxe to _generate this directly_ in our code output:

```haxe
var myArray = [0,1,2,3,4,5,6,7,8,9];
```

## Generate Array with Floats

Make sure all macro functions are separate from "normal" code. Therefore, we create a `Macros` class. 
As you see in the following code-example we changed `function` to `macro function` to make it execute when the code is compiling (compiletime). This is known as a macro function.

At this point we need to start converting to expressions, since you cannot simply return `points`, Haxe would throw an error _"Array&lt;Float&gt; should be haxe.macro.Expr"_.
To build our expressions, we will use [expression reification](https://haxe.org/manual/macro-reification-expression.html) which is an expensive word to create `haxe.macro.Expr` instances in a convenient way.

> **Expression reification in Haxe Manual:**  
> 
> * `$v{}`: Generates `Dynamic -> Expr` depending on the type of its argument. 
> * `$a{}`: Generates `Array<Expr> -> Array<Expr>` or `Array<Expr> -> Expr` if used in a place where an `Array<Expr>` is expected (e.g. call arguments, block elements), `$a{}` treats its value as that array. Otherwise it generates an array declaration.

Each float value of the list is converted to an expression using `$v{value}`.  
The final list with expressions is returned as `$a{exprs}`.

The return type of this `getFloats` function is `Expr`. For readability you can use `ExprOf<Array<Float>>` or keep it blank to leave it up to the compiler.

```haxe
class Macros {
  public static macro function getFloats() {
    // make array with floats
    var points:Array<Float> = [for (value in 0...10) value];

    // convert to expressions
    var exprs = [for(value in points) macro $v{value}];
    
    return macro $a{exprs};
  }
}
```

The usage in "normal code" is still easy to understand and the generated code will be exactly how we want it to be.
```haxe
// usage code
var myArray:Array<Float> = Macros.getFloats();

// will be generated as (this might differ slightly per Haxe target):
// var myArray = [0,1,2,3,4,5,6,7,8,9];
```

## Generate array with objects

Let's say you want to add instances of a certain object to the array, instead of the primitive types we used in the previous example. 
Assume you have a Point class like this:

```haxe
package com.utils;
class Point {
  public var x:Float;
  public var y:Float;
  public inline function new(x:Float, y:Float) {
    this.x = x;
    this.y = y;
  }
}
```

The macro function will be as demonstrated in the next code example. It converts the points array to Haxe expressions.

**Note:** you cannot use `$v{new com.utils.Point()}`, since `$v{}` only works on [basic types](https://haxe.org/manual/types-basic-types.html) (Float, Int, Bool) and [enum instances](https://haxe.org/manual/types-enum-instance.html).
To create the instance alone you can do `macro new Point(0,0)` but to provide a value from variable (like from our `points`) we need to convert the floats to expressions with `$v{}` again.

The return type of this `getPoints` function is `Expr`. For readability you can use `ExprOf<Array<Point>>` or keep it blank to leave it up to the compiler.
```haxe
class Macros {
  public static macro function getPoints() {
    // make array with Point instances
    var points:Array<Point> = [for (x in 0...10) new Point(x, 0)];

    // convert to expressions
    var exprs = [];
    for (point in points) {
      exprs.push(macro new com.utils.Point($v{point.x}, $v{point.y}));
    }
    
    return macro $a{exprs};
  }
}
```

The usage is as expected:
```haxe
var myArray:Array<Point> = Macros.getPoints();
```

Just for the sake of illustration; If you don't have a Point class but want to return a plain object `{x: point.x, y: point.y}`, it would look like this:
```haxe
// convert to expressions
var exprs = [];
for (point in points) {
  exprs.push(macro {x: $v{point.x}, y: $v{point.y}});
}
```

## Generate a multidimensional array

To add an array in an array, you need to create a list, then convert it to expressions of `$a{}` again. 

The return type of this `getPoints` function is `Expr`. For readability you can use `ExprOf<Array<Array<Point>>>` or keep it blank to leave it up to the compiler.

```haxe
class Macros {
  public static macro function getPoints() {
    // make multidimensional array with points
    var points:Array<Array<Point>> = [for (x in 0...10) [for (y in 0...10) new Point(x, y)]];

    // store expressions as Array<Array<Expr>>
    var exprs = [];
    for (row in points) {
      // convert to expressions
      var list = [for (point in row) macro new com.utils.Point($v{point.x}, $v{point.y})];
      
      // store as Array<Expr>
      exprs.push(macro $a{list});
    }
    
    return macro $a{exprs};
  }
}
```

And as expected its usage doesn't have any surprises:
```haxe
var myArray:Array<Array<Point>> = Macros.getPoints();
```


I hope this helps understanding expression building a bit more, Haxe macros are a very powerful feature.


> More on this topic: 
> 
> * [Macro Expression Reification](https://haxe.org/manual/macro-reification-expression.html)
> 
> Author: [Mark Knol](https://github.com/markknol)
