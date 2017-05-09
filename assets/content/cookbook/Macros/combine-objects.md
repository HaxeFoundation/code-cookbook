[tags]: / "expression-macro"

# Combine two or more structures

Haxe makes it easy to define extensions for a `typedef`, but there is no easy way to combine
the values of two or more structures to one, like `{a:2}` and `{b:"foo"}` to `{a:2,b:"foo"}`.
The following macro does this for you.

## Implementation

```haxe
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.Tools;
using Lambda;
#end


class StructureCombiner {
  // we use an Array<Expr>, because we want the macro to work on variable amount of structures
  public static macro function combine(rest: Array<Expr>): Expr {
    var pos = Context.currentPos();
    var block = [];
    var cnt = 1;
    // since we want to allow duplicate field names, we use a Map. The last occurrence wins.
    var all = new Map<String, { field: String, expr: Expr}>();
    for (rx in rest) {
      var trest = Context.typeof(rx);
      switch ( trest.follow() ) {
        case TAnonymous(_.get() => tr):
          // for each parameter we create a tmp var with an unique name.
          // we need a tmp var in the case, the parameter is the result of a complex expression.
          var tmp = "tmp_" + cnt;
          cnt++;
          var extVar = macro $i{tmp};
          block.push(macro var $tmp = $rx);
          for (field in tr.fields) {
            var fname = field.name;
            all.set(fname, { field: fname, expr: macro $extVar.$fname } );
          }
        default:
          return Context.error("Object type expected instead of "
            + trest.toString(), rx.pos);
      }
    }
    var result = {expr:EObjectDecl(all.array()), pos: pos};
    block.push(macro $result);
    return macro $b{block};
  }

}
```

## Usage

You can import the macro class with `using`.

```haxe
using StructureCombiner;

typedef Foo = { a: Int, b: Float }

typedef FooBar = { > Foo, bar: String };

static function callFoo() return { a: 42, b: 3.14 };

static function callBar() return { bar: "42" };

class Main {
  static function main() {
    // you can use the macro with function results
    var fb: FooBar = callFoo().combine(callBar());
    // or with variables and anonymous structures
    var foo: Foo = callFoo();
    fb = foo.combine({ bar: "42" });
    // more parameters are allowed
    fb = {a: 111}.combine({b:13.1}, {bar: "happy hour"});
    // when several structures have the same field, the last wins.
    var fb2 = fb.combine({bar: "lucky strike"});
  }
}
```

> Author: [Adrian Veith](https://github.com/AdrianV)
