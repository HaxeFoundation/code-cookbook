[tags]: / "conditional-compilation,expression-macro"

# Working with compiler flags

> This snippet demonstrates how to get, set, check for, and list compiler flags.

Compiler flags can be assigned values. For example, `-D key=value` defines a compiler flag called `key` with a value of `value`.

Compiler flag values representing numbers can be evaluated to `Float` and `Int`. Everything else is considered a `String` constant. If no value is assigned to a compiler flag key, the compiler defaults it to `1`. If a value of an undefined compiler flag key is requested, the compiler returns `null`.

It is possible to get and set compiler flags, check if they are defined, and list all defined compiler flags.

## Implementation
```haxe
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

class Main {
  static function main() {
    trace("Warning: " + Compiler.getDefine("warning"));
    #if !foo
    setDefine("foo", "bar");
    #end
    trace(getDefines());
  }

  // Shorthand for setting compiler flags from non-macro code.
  static macro function setDefine(key : String, value : String) : Expr {
    Compiler.define(key, value);
    return macro null;
  }

  // Shorthand for retrieving a map of all defined compiler flags.
  static macro function getDefines() : Expr {
    var defines : Map<String, String> = Context.getDefines();
    // Construct map syntax so we can return it as an expression
    var map : Array<haxe.macro.Expr> = [];
    for (key in defines.keys()) {
      map.push(macro $v{key} => $v{Std.string(defines.get(key))});
    }
    return macro $a{map};
  }
}
```

## Usage

Assume the following build file:

```hxml
-main Main
-neko main.n
-D warning="Don't let the bed bugs bite!"
```

Running `neko main.n` from the compiler output directory will result in:

```
Warning: "Don't let the bed bugs bite!"
{haxe3 => 1, haxe_ver => 3.201, dce => std, sys => 1, hxcpp_api_level => 321, true => 1, foo => bar, neko => 1, warning => "Don't let the bed bugs bite!"}
```

The last line may differ depending on the Haxe version and compilation options, because it is the string representation of the map containing all defined compiler flags.

> Learn about conditional compilation here: <https://haxe.org/manual/lf-condition-compilation.html>
>
> Learn about available global compiler flags here: <https://haxe.org/manual/compiler-usage-flags.html>
> 
> Learn about macro classes here: <https://api.haxe.org/haxe/macro/index.html>
>
> Author: [Domagoj Štrekelj](https://github.com/dstrekelj)
