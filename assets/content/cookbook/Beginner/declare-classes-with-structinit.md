[tags]: / "class"

# Declare classes using @:structInit

Apart from the [traditional way of instatiating classes using the `new` keyword](/category/beginner/declare-classes.html) - wich resembles how it's done in most object oriented languages such as java or C# - Haxe gives you an alternative, using the `@:structInit` class metadata.

When a class is annotated with `@:structInit` metadata...

```haxe
@:structInit class User {
	final name:String;
	var age:Int = 30;

	public function new(name:String, age:Int) {
		this.name = name;
		this.age = age;
	}

	public function greet()
		trace( 'Hello, I\'m $name, and I\'m $age years old!');
}
```
...it can be instantiated traditionally, with the `new` keyword...

```haxe
var bob:User = new User('Bob', 32);
```

...but it can also be instantiated using a compatible object structure, like the following:

```haxe
var bob:User = {name: 'Bob', age: 32};
```

If the class is a simple data object, without any need for initial method calls when instantiated, it can be declared even more compactly by removing the constructor:

```haxe
@:structInit class User {
	final name:String;
	var age:Int = 30;

	public function greet()
		trace('Hello, I\'m $name, and I\'m $age years old!');
}
```

Note that if the constructor is removed as above, `new` cannot be used for instantiaton:

```haxe
var bob:User = {name: 'Bob', age: 32}; // works!
var bob:User = {name: 'Bob'}; // defaults Bob's age to 30 years

var bob:User = new User('Bob', 32);// gives error "User does not have a constructor" 
```

## Why use @:structInit?

### Simple typedef-like syntax but with full class power

Typedefs might be the most common way to declare simple data objects, and @:structInit gives you a way to use the same simple syntax - but you also get all the bells and whistles of real classes: you can use `public` or `private` fields and methods, getters and setters etc. just like in any class.

### Performance gain on static targets

Haxe might [perform better on static targets when using classes compared to using typedefs or anonymous objects](https://haxe.org/manual/types-structure-performance.html). As a consequence, replacing typedefs with @:structInit classes might slightly increase the runtime performance.





