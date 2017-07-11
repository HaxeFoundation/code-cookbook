[tags]: / "build-macro,building-fields"

# Add a map

> This snippet demonstrates how to add a map field to a type.

We can use expression reification to turn basic types into appropriate expressions. Maps, however, are a _complex type_. As such they need to be treated a little differently.

A map is a container of key-value pairs that can be observed as an array of `key => value` expressions. For example: `var m = [ 1 => "ONE", 2 => "TWO"]`. With that in mind, building a map field is no different than creating an array of the correct expressions.

Note the use of `macro` to create the `key => value` expression. Also note the use of expression reification: `$v{}` to generate expressions from specified values, and `$a{}` to create the expression array.

## Build macro
```haxe
import haxe.macro.Context;
import haxe.macro.Expr;

class MapBuilder {
  public static macro function build(names : Array<String>) : Array<Field> {
    // The context is the class this build macro is called on
    var fields = Context.getBuildFields();
    // A map is an array of `key => value` expressions
    var map : Array<Expr> = [];
    // We add a `key => value` expression for every name
    for (name in names) {
      // Expression reification generates expression from argument
      map.push(macro $v{name} => $v{haxe.crypto.Sha256.encode(name)});
    }
    // We push the map into the context build fields
    fields.push({
      // The line position that will be referenced on error
      pos: Context.currentPos(),
      // Field name
      name: "namesHashed",
      // Attached metadata (we are not adding any)
      meta: null,
      // Field type is Map<String, String>, `map` is the map
      kind: FieldType.FVar(macro : Map<String, String>, macro $a{map}),
      // Documentation (we are not adding any)
      doc: null,
      // Field visibility
      access: [Access.APublic, Access.AStatic]
    });
    // Return the context build fields to build the type
    return fields;
  }
}
```

## Usage

```haxe
@:build(MapBuilder.build(["Aaron", "Bobbi", "Carol", "Dennis", "Eric", "Frank"]))
class Main {
  static function main() {
    trace(namesHashed.get("Bobbi"));
  }
}
```

> Learn about macros here: <http://haxe.org/manual/macro.html>
> 
> Author: [Domagoj Štrekelj](https://github.com/dstrekelj)
