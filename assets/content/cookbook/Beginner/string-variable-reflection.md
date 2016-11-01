[tags]: / "reflection,dead-code-elimination"

# Access a field using a string

This snippet shows how to use a string as a variable identifier using reflection.

## Implementation
```haxe
class MyObject {
  @:keep var myField:String = "This is Reflection Test";
  
  public function new() { }
}
```

## Usage
```haxe
class Main {
  static public function main():Void {
    var myObject = new MyObject();
    
    var fieldName = "myField";
    var myField:String = Reflect.field(myObject, fieldName);
    trace(myField); // "This is Reflection Test";
  }
}
```

Haxe has [dead code elimination](https://haxe.org/manual/cr-dce.html) (DCE). This compiler feature identifies and eliminates all unused code during compilation. In the example above, the variable `myField` is referenced only through reflection and not directly. Because of that, it will be marked for removal by DCE. To keep it from being eliminated, we need to add `@:keep` [compiler metadata](https://haxe.org/manual/cr-metadata.html) to the `myField` field. Note that `@:keep` could also be added to classes and functions. If you want to keep the class and its sub-classes, use `@:keepSub`.

**Tip:** Haxe has a wonderful type system, use this as much as possible. Reflection can be a powerful tool, but it's important to know it can be error prone, since the compiler can never validate if what you're doing makes sense and is also harder to optimize.

> **More information:**
> 
> * [Reflection documentation](http://haxe.org/manual/std-reflection.html)  
> * [Reflect API Documentation](http://api.haxe.org/Reflect.html)  
>
> Author: [MJ](https://github.com/flashultra)
