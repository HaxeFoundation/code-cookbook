[tags]: / "enum,expression-macro"

# Get all values of an @:enum abstract

The following macro function returns an array of all possible values of a given `@:enum abstract` type.
Since it's not possible in runtime (because abstracts doesn't exist there), we need to use a macro for that.

## Implementation

```haxe
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

class AbstractEnumTools {
  public static macro function getValues(typePath:Expr):Expr {
    // Get the type from a given expression converted to string.
    // This will work for identifiers and field access which is what we need,
    // it will also consider local imports. If expression is not a valid type path or type is not found,
    // compiler will give a error here.
    var type = Context.getType(typePath.toString());

    // Switch on the type and check if it's an abstract with @:enum metadata
    switch (type.follow()) {
      case TAbstract(_.get() => ab, _) if (ab.meta.has(":enum")):
        // @:enum abstract values are actually static fields of the abstract implementation class,
        // marked with @:enum and @:impl metadata. We generate an array of expressions that access those fields.
        // Note that this is a bit of implementation detail, so it can change in future Haxe versions, but it's been
        // stable so far.
        var valueExprs = [];
        for (field in ab.impl.get().statics.get()) {
          if (field.meta.has(":enum") && field.meta.has(":impl")) {
            var fieldName = field.name;
            valueExprs.push(macro $typePath.$fieldName);
          }
        }
        // Return collected expressions as an array declaration.
        return macro $a{valueExprs};
      default:
        // The given type is not an abstract, or doesn't have @:enum metadata, show a nice error message.
        throw new Error(type.toString() + " should be @:enum abstract", typePath.pos);
    }
  }
}
```

## Usage

```haxe
@:enum abstract MyEnum(Int) {
  var A = 1;
  var B = 2;
  var C = 3;
}

class Main {
  static function main() {
    var values = AbstractEnumTools.getValues(MyEnum);
    trace(values); // [1, 2, 3]
  }
}
```

> Author: [Dan Korostelev](https://github.com/nadako)
