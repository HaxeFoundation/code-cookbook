[tags]: / "class"

# Declare classes

Create a new class with two functions and create a new instance of it.

```haxe
class Calculator {
  public function new() {
    trace("A new calculator instance was created!");
  }
  
  public function add(a:Int, b:Int): Int {
    return a + b;
  }
  
  public function multiply(a:Int, b:Int):Int {
    return a * b;
  }
}

// Create a new instance of the Calculator
var calculator = new Calculator();

trace(calculator.add(1, 2));
trace(calculator.multiply(2, 3));
```
> See <http://haxe.org/manual/types-class-instance.html>

### Declare a class with inheritance

Create a parent class and create another one which "inherits" it.

```haxe
class Animal {
  public function new() { }
  
  public function sayHello() {
    trace("Hello!");
  }
}

class Dog extends Animal {
  public function new() {
    super();
  }
}

// Create a new Dog instance
var myDog = new Dog();

// We can also access its parent's methods
myDog.sayHello();
```
> See <http://haxe.org/manual/types-class-inheritance.html>

### Declare a class with fields

Declare a new class with its own fields, create a new instance and also be able to access and hide its properties.

```haxe
class User {
  public var name:String;
  private var age:Int;
  
  public function new(name:String, age:Int) {
    this.name = name;
    this.age = age;
  }
}

// Create a new User instance
var user = new User("Mark", 31);

// We can also access it's public variables
trace(user.name);

// But we cannot access it's private variables
trace(user.age); // Error; 
```
> See <http://haxe.org/manual/class-field.html>

### Declare a generic class 

Declare a new class with its own fields, create a new instance and also be able to access and hide its properties.

```haxe
class Value<T> {
  public var value:T;
  
  public function new(value:T) {
    this.value = value;
  }
}

// Create a new Value Int instance
var myIntValue = new Value<Int>(5);

// Create a new Value String instance
var myStringValue = new Value<String>("String");

```
> See <http://haxe.org/manual/type-system-generic.html>

### Declare an inline constructor 

Declare a new class with an inline constructor (`new()` function), create a new instance and reveal its effect.

```haxe
class Point {
  public var x:Float;
  public var y:Float;

  public inline function new(x, y) {
    this.x = x;
    this.y = y;
  }
}

// Create a new Value Int instance
var myPoint = new Point(100, 150);
trace(myPoint.x);
```
In JavaScript, this will be compiled (where possible) as:
```js
var myPoint_x = 100;
var myPoint_y = 150;
console.log(myPoint_x);
```
> See <http://haxe.org/manual/lf-inline-constructor.html>
