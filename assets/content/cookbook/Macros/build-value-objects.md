[tags]: / "build-macro,building-fields"

# Create value-objects

This example generates a constructor-function for each field of a class to easily create value object classes.

```haxe
import haxe.macro.Expr;
import haxe.macro.Context;

@:remove @:autoBuild(ValueClassImpl.build())
extern interface ValueClass {}

class ValueClassImpl {
#if macro
  public static function build() {
    var fields = Context.getBuildFields();
    var args = [];
    var states = [];
    for (f in fields) {
      switch (f.kind) {
        case FVar(t,_):
          args.push({name:f.name, type:t, opt:false, value:null});
          states.push(macro $p{["this", f.name]} = $i{f.name});
          f.access.push(APublic);
        default:
      }
    }
    fields.push({
      name: "new",
      access: [APublic],
      pos: Context.currentPos(),
      kind: FFun({
        args: args,
        expr: macro $b{states},
        params: [],
        ret: null
      })
    });
    return fields;
  }
#end
}
```

It is using an interface `ValueClass` marked with `@:remove` and `extern` so that it is 100% compile time only.

## Usage

Create a class that implements `ValueClass`. 

```haxe
class ABC implements ValueClass {
  var a: Int;
  var b: Bool;
  var c: String;
}
```

Will be compiled as:

```haxe
class ABC extends ValueClass {
  public var a(default, null): Int;
  public var b(default, null): Bool;
  public var c(default, null): String;
  public function new(a: Int, b: Bool, c: String) {
    this.a = a;
    this.b = b;
    this.c = c;
  }
}
```

> Source: <https://gist.github.com/puffnfresh/5314836>