[tags]: / "class"

# Declare variables

### Declare a variable without a declared type
Create a variable without a declared type. Although the type is not explicity declared, you cannot reassign the variable later to a different type.

```haxe
var foo = 2;
trace(foo); // traces 2

foo = "2"; // will trow error "String should be Int"
```


### Declare a variable with a declared type

Create a variable with type.

```haxe
var foo:Int = 2;
var bar:String = "2";
```

### Inital values of variables

In Haxe, variables are null until used - including number types.

```haxe
var foo:Int;
trace(foo == null); //output true;
```


### Redeclaration of variables

If you redeclare a variable in the local scope you will not recieve an error, the local scope value will be used.

```haxe
  var foo:Int = 0;
  function demonstrateDifferentScopes() {
    outputClassVar();
    outputLocalVar();
  }
  
  static function outputClassVar()
  {
    trace(foo); //output 0
  }
  
  static function outputLocalVar()
  {
    var foo:Int = 1;
	trace(foo); //output 1
  }
```
