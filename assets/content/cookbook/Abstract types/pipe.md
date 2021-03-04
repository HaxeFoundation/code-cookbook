[tags]: / "abstract-type"

# Pipe using Abstract Operator Overloading

> The following example demonstrates how the pipe operator is used to clean up nested function calls with Abstract Operator Overloading.

## Motivation

Function calls can take up a lot of real estate when transforming data. A developer may need to transform data through multiple utility functions. In doing so the developer may create temporary variables to transfer value from and to each function or they may write code using function calls as function arguments. Piping data from one function to another and assigning the data to a single identifier cleans up unnecessary variables while still showing the developers intention.

## Abstract Pipe

```haxe
abstract Pipe<T>(T) to T {
	public inline function new(s:T) {
		this = s;
	}

	@:op(A | B)
	public inline function pipe1<U>(fn:T->U):Pipe<U> {
		return new Pipe(fn(this));
	}

	@:op(A | B)
	public inline function pipe2<A, B>(fn:T->A->B):Pipe<A->B> {
		return new Pipe(fn.bind(this));
	}

	@:op(A | B)
	public inline function pipe3<A, B, C>(fn:T->A->B->C):Pipe<A->B->C> {
		return new Pipe(fn.bind(this));
	}

	@:op(A | B)
	public inline function pipe4<A, B, C, D>(fn:T->A->B->C->D):Pipe<A->B->C->D> {
		return new Pipe(fn.bind(this));
	}
}
```
## Usage

```haxe
function addWorld(str:String):String {
	return str + " world!";
}

function capitalize(str:String):String {
	return str.toUpperCase();
}

function count(str:String):Int {
	return str.length;
}

// function call as argument version
var nestedHelloWorld = capitalize(addWorld("Hello"));
trace(nestedHelloWorld); // HELLO WORLD!

// update variable version
var hello = "Hello";
hello = addWorld(hello);
hello = capitalize(hello);
trace(hello); // HELLO WORLD!

// piped version
var helloWorld:String = new Pipe("Hello")
  | addWorld
  | capitalize;
trace(helloWorld); // HELLO WORLD!

// piped version changing type from String to Int
var helloWorldCount:Int = new Pipe("Hello")
  | addWorld
  | capitalize
  | count;
trace(helloWorldCount / 2); // 6
```

> Learn about Haxe Abstracts here: <http://haxe.org/manual/types-abstract.html>
> 
> Author: [Jeremy Meltingtallow](https://github.com/PongoEngine)
