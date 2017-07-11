[tags]: / "build-macro,building-fields"

# Add property with getter

> Virtually adds this property to a class:
> ```haxe
> public var myVar(get, null):Float;
> private inline function get_myVar():Float {
>   return 1.5;
> }
> ```

## Build macro

```haxe
import haxe.macro.Context;
import haxe.macro.Expr;
class MyMacro {
  public static function build():Array<Field> {
    // get existing fields from the context from where build() is called
    var fields = Context.getBuildFields();
    
    var value = 1.5;
    var pos = Context.currentPos();
    var fieldName = "myVar";
    
    var myFunc:Function = { 
      expr: macro return $v{value},  // actual value
      ret: (macro:Float), // ret = return type
      args:[] // no arguments here
    }
    
    // create: `public var $fieldName(get,null)`
    var propertyField:Field = {
      name:  fieldName,
      access: [Access.APublic],
      kind: FieldType.FProp("get", "null", myFunc.ret), 
      pos: pos,
    };
    
    // create: `private inline function get_$fieldName() return $value`
    var getterField:Field = {
      name: "get_" + fieldName,
      access: [Access.APrivate, Access.AInline],
      kind: FieldType.FFun(myFunc),
      pos: pos,
    };
    
    // append both fields
    fields.push(propertyField);
    fields.push(getterField);
    
    return fields;
  }
}
```

### Usage 

```haxe
@:build(MyMacro.build())
class Main {
  public function new() {
    trace(this.myVar); // 1.5;
  }
}
```

> Author: [Mark Knol](https://github.com/markknol)
