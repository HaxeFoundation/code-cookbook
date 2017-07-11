[tags]: / "expression-macro,building-fields"

# Add parameters as fields

This macro function automatically assigns parameters of method to local variables.

```haxe
import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;

class MyMacros {
   macro static public function initLocals():Expr {
    // Grab the variables accessible in the context the macro was called.
    var locals = Context.getLocalVars();
    var fields = Context.getLocalClass().get().fields.get();

    var exprs:Array<Expr> = [];
    for (local in locals.keys()) {
      if (fields.exists(function(field) return field.name == local)) {
        exprs.push(macro this.$local = $i{local});
      } else {
        throw new Error(Context.getLocalClass() + " has no field " + local, Context.currentPos());
      }
    }
    // Generates a block expression from the given expression array 
    return macro $b{exprs};
  }
}
```

## Usage 

```haxe
class Test {
  public var name:String;
  public var x:Float;
  public var y:Float;
  
  public function new(name:String, x:Float, y:Float) {
    MyMacros.initLocals();
  }
}
```

This will be the same as writing this manually:
  
```haxe
class Test {
  public var name:String;
  public var x:Float;
  public var y:Float;

  public function new(name:String, x:Float, y:Float) {
    this.name = name;
    this.x = x;
    this.y = y;
  }
}
```

> Author: [Mark Knol](https://github.com/markknol)
