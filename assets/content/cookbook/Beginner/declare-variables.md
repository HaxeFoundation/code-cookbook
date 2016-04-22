[tags]: / "class"

# Declare variables

Create a variable without type. Although the type is not explicity declared, you cannot reassign the variable later to a different type.

```haxe
var foo = 2;
trace(foo); // traces 2

foo = "2"; // will trow error "String should be Int"
```


### Declare a variable with type

Create a variable with type.

```haxe
var foo:Int = 2;
var bar:String = "2";
```

### Declare variable with Dynamic type

Create a variable with Dynamic type. By declaring a variable Dynamic, you may reassign value to the variable.


```haxe
var foo:Dynamic = 2;
trace(Std.is(foo, Int)); //true
foo = "2";
trace(Std.is(foo, String)); //true
```
