[tags]: / "enum,abstract-type,pattern-matching,type-parameter,type-parameter-constraint"

# Passing different types to a function parameter

Sometimes you find yourself in the need of passing different types to the same parameter of a function. While there isn't a built-in way of doing this in Haxe, thanks to its flexible type system, we can solve this problem. We will explore two ways to achieve this.

### Access fields that are present in all our types

Let's say, for example, that we want to get the `length` of an `Array<T>` or an `String`:

```haxe
function length(o:Array<Int>/*or String*/):Int {
  return o.length;
}
```

That function won't work for us, it will only work for `Arrays` so we need to find a way to fix it. *The laziest* and **more dangerous** method we can use is [`Dynamic`](http://api.haxe.org/Dynamic.html).

```haxe
function length(o:Dynamic):Int {
  return o.length;
}
```

[tryhaxe](http://try.haxe.org/embed/1639D)

The problem with this method is, as the [manual says](http://haxe.org/manual/types-dynamic.html), that we can pass anything to the function and the compiler won't care about it, leaving any error or exception to the target language. 

### Getting rid of `Dynamic`

Isn't there a safer way of doing this so we can catch any error at compile time? We know that both types have a `length(default, null):Int` field and we are only interested on the `length` field. We can then use [type parameter constraints](http://haxe.org/manual/type-system-type-parameter-constraints.html).

```haxe
function length<T:{var length(default, null):Int;}>(o:T) {
  return o.length;
}
```

[tryhaxe](http://try.haxe.org/embed/840Cf)

Or, if we are going to use the constraint in more functions, we can use a [`typedef`](http://haxe.org/manual/type-system-typedef.html)

> _Haxe Manual:_ A typedef can give a name to any other type and/or describe a complex structure.

```haxe
typedef Length = {
  var length(default, null):Int;
}

function length<T:Length>(o:T) {
  return o.length;
}

function length2<T:Length>(o:T) {
  return o.length * 2;
}
```

[tryhaxe](http://try.haxe.org/embed/530F7)

Of course, this will only work if we can constraint the types somehow. But what if we can't?

### Using different types

Now, we need a function that takes an `Array<Int>` or an `Int` so we can return an `Array<Int>` after adding a few numbers. 
If we pass an `Array` it will return the same `Array` with the new numbers added. 
If we pass an `Int` it will create an `Array<Int>` from 0 to the value passed and add the new numbers to it. 
The problem here is we can't use the same method we used before because there isn't any constraint we can use for these types.

We can try to use `Dynamic` again, but as we saw before it isn't type safe and error-prone: All the errors or exceptions will be at runtime and the compiler won't warn us if we pass another invalid type.  
We will also lose the type of the `Array` (`Int`) because this information is only used at compile time and erased at runtime. This is why we can't use `Std.is(o, Array<Int>)`.

```haxe
function add(o:Dynamic):Array<Int> {
  var a:Array<Int>;
  if(Std.is(o, Array)) {
    a = cast o;
  } else if(Std.is(o, Int)) {
    a = [for(i in 0...Std.int(o)) i];
  } else {
    throw "The value isn't an Array or an Int";
  }

  a.push(100);
  a.push(300);

  return a;
}
```

[tryhaxe](http://try.haxe.org/embed/a2c00)

### Making it more type safe with `Either` 

There is a more type safer way that let the compiler catch possible errors at compile time. 
We can use [`haxe.ds.Either`](http://api.haxe.org/haxe/ds/Either.html).
It has to be mentioned that `Either` gives some runtime performance overhead, but it brings type safety which we are looking for.

> _Haxe Manual:_ `Either` represents values which are either of type `L` (Left) or type `R` (Right).

```haxe
function add(o:haxe.ds.Either<Array<Int>, Int>):Array<Int> {
  var a:Array<Int>;
  switch(o) {
    case Left(l): a = l;
    case Right(r): a = [for(i in 0...r) i];
  }

  a.push(100);
  a.push(300);

  return a;
}
```

Now the `add` function can be used like demonstrated here:

```haxe
trace("Passing an Array<Int>: " + add(Left([10, 20, 30])));
trace("Passing an Int: " + add(Right(3)));
```

[tryhaxe](http://try.haxe.org/embed/6dA36)

Great! The code is now type safe and the compiler will error if we give it the wrong types, but isn't it a bit cumbersome?
We need to remember that if we want to pass an `Array<Int>` we need to use `Left()` and if we want to pass an `Int` we need to use `Right()`.

Let's make it easier to work with!

### Taking it further with abstract types

This method will solve the problems every other method had. It's based on the last method but, thanks to the powerful Haxe [abstract types](http://haxe.org/manual/types-abstract.html), we can let the compiler do the job for us.

> _Haxe Manual:_ An abstract type is a type which is actually a different type at run-time. It is a compile-time feature which defines types "over" concrete types in order to modify or augment their behavior.

First of all we need to write the abstract. By defining the `@:to` and `@:from` functions we define the casts to/from one to another type. 

```haxe
import haxe.ds.Either;

abstract OneOf<A, B>(Either<A, B>) from Either<A, B> to Either<A, B> {
  @:from inline static function fromA<A, B>(a:A):OneOf<A, B> {
    return Left(a);
  }
  @:from inline static function fromB<A, B>(b:B):OneOf<A, B> {
    return Right(b);  
  } 
    
  @:to inline function toA():Null<A> return switch(this) {
    case Left(a): a; 
    default: null;
  }
  @:to inline function toB():Null<B> return switch(this) {
    case Right(b): b;
    default: null;
  }
}
```

We can now modify our `add()` function to:

```haxe
function add(o:OneOf<Array<Int>, Int>):Array<Int> {
  var a:Array<Int>;
  switch(o) {
    case Left(l): a = l;
    case Right(r): a = [for(i in 0...r) i];
  }

  a.push(100);
  a.push(300);

  return a;
}
```

[tryhaxe](http://try.haxe.org/embed/4f2Dd)

Nice! We get type safety. 
We will get compile time errors if we by accident pass incorrect types to our method. 
The compiler does the dirty job for us. 

---

You may be wondering _"what if I want to use more types?"_  
Well, `haxe.ds.Either` is just an `enum` (see its [source code](https://github.com/HaxeFoundation/haxe/blob/development/std/haxe/ds/Either.hx)) so nothing stops you from writing an `enum` with more type parameters and modify `OneOf` to accept more `@:from` and `@:to`. 

Of course, you can always use [macros](http://haxe.org/manual/macro.html) to create it and the abstract but we will leave that for another day.


> **Learn more:**
> 
> * [Haxe abstract types](http://haxe.org/manual/types-abstract.html)
> * [Type parameter constraints](http://haxe.org/manual/type-system-type-parameter-constraints.html)
> 
> Author: [Justo Delgado](https://github.com/mrcdk)

