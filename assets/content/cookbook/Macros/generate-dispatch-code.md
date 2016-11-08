[tags]: / "arguments,building-fields,build-macro"

# Generate dispatch code

Automatically generate dispatch functions as:

```haxe
public function onDoubleArguments(one:String, two:Int) {
  for (listener in listeners) {
    listener.onDoubleArguments(one, two);
  }
}
```

## Macro builder class

```haxe
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

class DispatchBuilder {
  macro static public function build():Array<Field> {
    var fields = Context.getBuildFields();
    for (field in fields) {
      // skip the constructor
      if (field.name == 'new') continue;
      
      switch (field.kind) {
        case FieldType.FFun(fn):
          // skip non-empty functions
          if (!isEmpty(fn.expr)) continue;
          
          // empty function found, create a loop and set as function body
          var fname = field.name;
          var args = [for (arg in fn.args) macro $i{arg.name}];
          fn.expr = macro {
            for (listener in listeners)
              listener.$fname( $a{args} );
          }
        default:
      }
    }
    return fields;
  }

  static function isEmpty(expr:Expr) {
    if (expr == null) return true;
    return switch (expr.expr) {
      case ExprDef.EBlock(exprs): exprs.length == 0;
      default: false;
    }
  }
}
#end
```

## Usage

You will need to create a `Dispatcher` base class. 

```haxe
@:autoBuild(DispatchBuilder.build())
class Dispatcher<T> {
  var listeners:Array<T>;

  public function new() {
    listeners = [];
  }

  // addListener, removeListener,...
}
```

Extend `Dispatcher` to profit from automatically generated dispatch functions.

```haxe
class Example extends Dispatcher<Dynamic> {
  public function onDoubleArguments(one:String, two:Int);
  public function onSingleArgument(one:String);
  public function onNoArgument();
  public function onEmptyBody() { }
  public function onNonEmptyBody() {
    trace('my code here');
  }
}
```

> Source: <https://gist.github.com/elsassph/d3d1f1dc461d50eface1>  
> Author: [Philippe elsassph](https://github.com/elsassph)
