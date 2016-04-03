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