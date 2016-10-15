[tags]: / "beginner,other"

# Using string as variable (with reflection)

Extract variable name from string and using it as variable

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

Haxe have dead-code elimination enabled by default.In the example, the variable 'ref' is not referenced anywhere, so it will be removed. We need to add @:keep to that field, because it's only referenced by reflection.

> More on this topic: <http://haxe.org/manual/std-reflection.html>
> 
> Author: [MJ](https://github.com/flashultra)
