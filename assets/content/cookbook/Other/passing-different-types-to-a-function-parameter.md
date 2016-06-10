[tags]: / "enum,abstract-type,pattern-matching,type-parameter,type-parameter-constraint"

# Passing different types to a function parameter

Sometimes you find yourself in the need of passing different types to the same parameter in function. While there isn't a builtin way of doing this in Haxe, thanks to its type system, we can solve this problem (with some runtime overhead)

### We want to access a few fields that are present in our types

Let's say, for example, that we want to get the `length` of an `Array<T>` or an `String`:

```haxe
function length(o:Array<Int>/*or String*/):Int {
  return o.length;
}
```

That will only work for `Arrays` so we need to find a way to fix it. *The laziest* and **more dangerous** method we can use is `Dynamic`

```haxe
function length(o:Dynamic):Int {
  return o.length;
}
```

[tryhaxe](http://try.haxe.org/embed/1639D)

The problem with this method is that we can pass anything to the function and the compiler won't care about it, leaving any error or exception to the target language. 

---

Isn't there a safer way of doing this so the error come at compile time? We know that both types have a `length(default, null):Int` field and we are only interested on that field. We can then use [Type parameter constraints](http://haxe.org/manual/type-system-type-parameter-constraints.html)

```haxe
function length<T:{var length(default, null):Int;}>(o:T) {
  return o.length;
}
```

[tryhaxe](http://try.haxe.org/embed/840Cf)

Or, if we are going to use the constraint in more functions, we can use a `typedef`

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

Of course, this will only work if we can constraint the types somehow, what if we can't?

### We want to use different types

Now, we need a function that takes an `Array<Int>` or an `Int` so we can return an `Array<Int>` after adding a few numbers. If we pass an `Array` it will return the same `Array` with the new numbers added, if we pass an `Int` it will create an `Array<Int>` from 0 to the value passed and add the new numbers to it.

We can't use the same method we used before because there isn't any constraint we can write for these types.

We can try again to use `Dynamic`, but as we saw before, it's  *the laziest* and **more dangerous** method we can use because all the errors or exceptions will be at runtime and the compiler won't warn us if we pass another type. 
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

> We also lose the type of the `Array` (`Int`) because this information is only used at compile time and erased at runtime. This is why we can't use `Std.is(o, Array<Int>)`

[tryhaxe](http://try.haxe.org/embed/a2c00)

---

Is there another way more type safer and that can throw possible errors at compile time? Yes there is! We can use [`haxe.ds.Either`](http://api.haxe.org/haxe/ds/Either.html)

```haxe
function add(o:haxe.ds.Either<Array<Int>, Int>):Array<Int> {
  var a:Array<Int>;
  switch(o) {
    case Left(x): a = x;
    case Right(x): a = [for(i in 0...x) i];
  }

  a.push(100);
  a.push(300);

  return a;
}
```

And we can use it like:

```haxe
trace("Passing an Array<Int>: " + add(Left([10, 20, 30])));
trace("Passing an Int: " + add(Right(3)));
```

[tryhaxe](http://try.haxe.org/embed/6dA36)

Great! The code is not type safe and the compiler will error if we give it the wrong types but... isn't it a bit cumbersome? We need to remember that if we want to pass an `Array<Int>` we need to use `Left()` and if we want to pass an `Int` we need to use `Right()` Can we make it easier to work with? The answer is... **yes!**

---

This method solves all the problems every other method had. It's based on the last method but, thanks to the powerful Haxe [abstracts](http://haxe.org/manual/types-abstract.html) types, we can let the compiler do the job for us.

First of all we need to write the abstract:

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

And we will need to modify our `add()` function to:

```haxe
function add(o:OneOf<Array<Int>, Int>):Array<Int> {
  var a:Array<Int>;
  switch(o) {
    case Left(x): a = x;
    case Right(x): a = [for(i in 0...x) i];
  }

  a.push(100);
  a.push(300);

  return a;
}
```

[tryhaxe](http://try.haxe.org/embed/4f2Dd)

Nice! We get type safety, compile time errors and we can make the compiler do the dirty job. 

---

You may be wondering "what if I want to use more types?" Well, `haxe.ds.Either` is just an `enum` ([source code](https://github.com/HaxeFoundation/haxe/blob/development/std/haxe/ds/Either.hx)) so nothing stops you from writing an `enum` with more type parameters and modify `OneOf` to accept more `@:from` and `@:to`. Of course, you can always use **macros** to create it and the abstract.


> Learn more about Haxe abstract types: <http://haxe.org/manual/types-abstract.html>
> Learn more about Type parameter constraints: <http://haxe.org/manual/type-system-type-parameter-constraints.html>
> 
> Author: [Justo Delgado Baudí](https://github.com/mrcdk)
