[tags]: / "reflection,dead-code-elimination"

# Invoke object method by string

To invoke method by it's name you will need to use Reflection API.

Snippet bellow shows how to use a string as a object method identifier to invoke it.

## Usage
```haxe
class MyClass {
    public function new () {}
    @:keep public function printName() {
        trace("MyClass printName is invoked");
    }
}

class Main {
    static function main() {
        var myObject = new MyClass();
        var f = Reflect.field(myObject, "yo");
        Reflect.callMethod(myObject, cast f, []);
    }
}
```

Haxe has [dead code elimination](https://haxe.org/manual/cr-dce.html) (DCE) which remove from generated code classes, methods and variables not used from directly. In the example, method `printName()` is used by reflection and has no referencies anywhere else, so it will be removed in compile time. To keep `printName()` method after compilation switch off DCE or mark this method by `@:keep` [metadata](https://haxe.org/manual/cr-metadata.html).

**Tip:** Haxe has a wonderful type system, use this as much as possible. Reflection can be a powerful tool, but it's important to know it can be error prone, since the compiler can never validate if what you're doing makes sense and is also harder to optimize.

> **More information:**
> 
> * [Reflection documentation](http://haxe.org/manual/std-reflection.html)  
> * [Reflect API Documentation](http://api.haxe.org/Reflect.html)  
>
> Author: [Alexey](https://github.com/alexey-kolonitsky)
