# Declare functions

```haxe
// Declare our new function
function myFunction() {
  trace("Hello!");
}

// Call it
myFunction();
```

### Declare function with arguments

```haxe
// Declare our new function
function sayHelloTo(name:String) {
  trace('Hello ${name}');
}

// Call it
sayHelloTo("Mark");
```

### Declare function with arguments

```haxe
// Declare our new function
function sayHelloTo(name:String) {
  trace('Hello ${name}');
}

// Call it
sayHelloTo("Mark");
```
> See <http://haxe.org/manual/types-function.html>

### Declare functions with default arguments

```haxe
// Declare a function with one parameter which has a default value set
function sayHello(name:String = "Mark") {
  trace('Hello ${name}');
}

// Call it without any parameter and the 'default' one will be used
sayHello();

// Let's call it again with some parameter
sayHello("John");
```
> See <http://haxe.org/manual/types-function-default-values.html>

### Declare functions with optional arguments

```haxe
// Declare a function with one optional parameter
function sayHello(?name:String) {
  if (name != null) {
    trace('Hello ${name}');
  } else {
    trace('No name');
  }
}

// Call it without any parameter and the 'default' one will be used
sayHello();

// Let's call it again with some parameter
sayHello("Sander");
```
> See <http://haxe.org/manual/types-function-optional-arguments.html>

### Declare a function with return type

```haxe
// Declare our new function
function sum(a:Int, b:Int):Int {
  return a + b;
}

// Call it
var result = sum(2, 4);
trace(result);
```
> See <http://haxe.org/manual/types-function.html>

### Declare a function with parameterized arguments

```haxe
// Declare our new function
function equals<T>(a:T, b:T):Bool {
  return a == b;
}

// Call it with integers
trace(equals(2, 2)); // true
trace(equals(2, 1)); // false

// Call it with strings
trace(equals("hello","hello")); // true
trace(equals("hello","world")); // false
```
> See <http://haxe.org/manual/type-system-type-parameters.html>