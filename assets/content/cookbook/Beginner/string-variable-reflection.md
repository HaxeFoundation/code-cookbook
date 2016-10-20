[tags]: / "reflection"

# Using a string as a variable (with reflection)

This snippet shows how to use a string as a variable identifier.

## Implementation
```haxe
class ReflectionTest {
  @:keep var ref : String = "This is Reflection Test";
  
  public function show() 
  {
    var t : String = Reflect.field(this,"ref");
    trace(t);
  }
	
  public function new()
  {
  }
}
```

## Usage
```haxe
class Main {
  static public function main():Void {
    var r : ReflectionTest = new ReflectionTest();
    r.show();
  }
}
```

Haxe has dead code elimination (DCE) enabled by default. This compiler feature identifies and eliminates all unused code during compilation. In the example above, the variable ref is referenced only through reflection and not directly. Because of that, it will be marked for removal by DCE. To keep it from being eliminated, we need to add @:keep compiler metadata to the ref field.


> [Reflection API documentation](http://haxe.org/manual/std-reflection.html)
> 
> [Dead Code Elimination](https://haxe.org/manual/cr-dce.html)
>
> [Built-in Compiler Metadata](https://haxe.org/manual/cr-metadata.html)
>
> Author: [MJ](https://github.com/flashultra)
