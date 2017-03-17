[tags]: / "enum,pattern-matching,expression-macro"

# Extract values from known enum instances

Sometimes we have an instance of `enum` that is of known constructor (or we only accept that constructor) and we
want to extract values from that instance. Normally, to do this, we have to use pattern matching (`switch`), however
it's quite verbose, so we can instead use this macro static extension method that will generate switch for us.

## Implementation

```haxe
#if macro
import haxe.macro.Expr;
#end

class Tools {
  public static macro function extract(value:ExprOf<EnumValue>, pattern:Expr):Expr {
    switch (pattern) {
      case macro $a => $b:
        return macro switch ($value) {
          case $a: $b;
          default: throw "no match";
        }
      default:
        throw new Error("Invalid enum value extraction pattern", pattern.pos);
    }
  }
}
```

## Usage

```haxe
using Tools;

class Main {
  static function main() {
    var opt = haxe.ds.Option.Some(10);
    var val = opt.extract(Some(v) => v);
    trace(val == 10); // true
  }
}
```

> Author: [Dan Korostelev](https://github.com/nadako)
