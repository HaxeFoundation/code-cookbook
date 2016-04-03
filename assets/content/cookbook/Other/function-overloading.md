[tags]: / "overload"

# Function overloading

Haxe doesn't offer [function overloading](https://en.wikipedia.org/wiki/Function_overloading) natively but that doesn't mean there is no way to mimic this funtionality. 

In these snippets we will cover some ways to _enable_ function overloading in Haxe. We will try to mimic this example:

```haxe
// This code won't work in Haxe

function test(s:String) {
  trace("The length of the string is: " + s.length);
}

function test(i:Int) {
  trace("The number is: " + i);
}

```

### Dynamic and Std.is()

```haxe
function test(o:Dynamic) {
  if(Std.is(o, String)) {
    trace("The length of the string is: " + Std.string(o).length);
  } else if(Std.is(o, Int)) {
    trace("The number is: " + Std.int(o));
  } else {
    trace("This function only accept Strings and Ints");
  }
}

// Usage
test("hello");
test(10);
test(true);   // This is accepted and the code will compile
```

[tryhaxe](http://try.haxe.org/embed/Fe9C2)

### Using optional parameters

```haxe
function test(?s:String, ?i:Int) {
  if(s != null && i != null) {
    trace("This function only accept a String OR an Int");
    return;
  }
  
  if(s != null) {
    trace("The length of the string is: " + s.length);
  }
  if(i != null) {
    trace("The number is: " + i);
  } 
}

// Usage
test("hello");
test(10);
test("hello", 10);   // This is accepted and the code will compile

```

[tryhaxe](http://try.haxe.org/embed/C22cF)

### Using haxe.ds.Either

```haxe
function test(o:haxe.ds.Either<String, Int>) {
  switch(o) {
    case Left(s):
      trace("The length of the string is: " + s.length);
    case Right(i):
      trace("The number is: " + i);
  }
}

// Usage
test(Left("hello"));
test(Right(10));
test(true);		      // This will throw a compile time error.
```

[tryhaxe](http://try.haxe.org/embed/C22cF)

### Using haxe.ds.Either with an abstract

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

...

static function test(o:OneOf<String, Int>) {
  switch(o) {
    case Left(s):
      trace("The length of the string is: " + s.length);
    case Right(i):
      trace("The number is: " + i);
  }
} 

// Usage
test("hello");
test(10);
test(true);		      // This will throw a compile time error.
```

[tryhaxe](http://try.haxe.org/embed/ab998)
