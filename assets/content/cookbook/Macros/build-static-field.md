[tags]: / "build-macro,building-fields"

# Add a static field

> Virtually adds this static variable to a class:
> ```haxe
> public inline static var STATIC_VAR:Float = 1.5;
> ```

## Build macro
```haxe
import haxe.macro.Context;
import haxe.macro.Expr;

class MyMacro {
  public static function build():Array<Field> {
    // get existing fields from the context from where build() is called
    var fields = Context.getBuildFields();
    
    // append a field
    fields.push({
      name:  "STATIC_VAR",
      access:  [Access.APublic, Access.AStatic, Access.AInline],
      kind: FieldType.FVar(macro:Float, macro $v{1.5}), 
      pos: Context.currentPos(),
    });
    
    return fields;
  }
}
```

## Usage

```haxe
@:build(MyMacro.build())
class Main {
  public function new() {
    trace(Main.STATIC_VAR); // 1.5;
  }
}
```

> Author: [Mark Knol](https://github.com/markknol)