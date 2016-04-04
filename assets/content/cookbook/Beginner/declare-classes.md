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
  
  public function new(name:String, age:Float) {
    this.name = name;
    this.age = age;
  }
}

// Create a new Dog instance
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
