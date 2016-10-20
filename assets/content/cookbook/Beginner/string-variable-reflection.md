[tags]: / "reflection"

# Using a string as a variable (with reflection)

This snippet shows how to use a string as a variable identifier.

## Implementation
```haxe
class ReflectionTest {
  @:keep var ref:String = "This is Reflection Test";
  
  public function test() {
    var t:String = Reflect.field(this, "ref");
    trace(t);
  }
	
  public function new() { }
}
```

## Usage
```haxe
class Main {
  static public function main():Void {
    var r:ReflectionTest = new ReflectionTest();
    r.test();
  }
}
```

Haxe has [dead code elimination](https://haxe.org/manual/cr-dce.html) (DCE) enabled by default. This compiler feature identifies and eliminates all unused code during compilation. In the example above, the variable `ref` is referenced only through reflection and not directly. Because of that, it will be marked for removal by DCE. To keep it from being eliminated, we need to add `@:keep` [compiler metadata](https://haxe.org/manual/cr-metadata.html) to the `ref` field. Note that `@:keep` could also be added to classes and functions. If you want to keep the class and its sub-classes, use `@:keepSub`.

**Tip:** Haxe has a wonderful type system, use this as much as possible. Reflection can be a powerful tool, but it's important to know it can be error prone, since the compiler can never validate if what you're doing makes sense and is also harder to optimize.

> [Reflection documentation](http://haxe.org/manual/std-reflection.html)  
> [Reflect API Documentation](http://api.haxe.org/Reflect.html)  
>
> Author: [MJ](https://github.com/flashultra)
