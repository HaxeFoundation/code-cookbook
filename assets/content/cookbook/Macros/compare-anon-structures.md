# Compare Anonymous Structures and Objects

## Why use a macro

Sometimes it can be useful to compare two anonymous structures or objects
 by their properties, even if they're not the same.

For example, if we have two objects, `a` and `b`:

```haxe
var a = {
  valA : 1,
  valB : 2,
  valC : 3,
  valD : 4,
};

var b = {
  valA : 1,
  valB : 2,
  valC : 3,
  valD : 4,
  someOtherValue : 'value'
};
```

And wish to ensure `b`'s properties match all of `a`'s properties,
 we would need the following construct:

```haxe
// Ensure b has all fields of a.

trace( a.valA == b.valA &&
       a.valB == b.valB &&
       a.valC == b.valC &&
       a.valD == b.valD );
```

Since a simple `==` comparison yields an error; the objects are
 not of the same type.
We can automatize this comparison using Macros.

## Macro

```haxe
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class CompareMacro {
  macro static public function matchAllFromAnon(reference:Expr, shouldHave:Expr):Expr {
    var conds:Array<Expr> = [];
    var curPos = Context.currentPos();
    
    var fieldsToCheck = [];
    var typeOfReference = Context.typeof(reference);
    switch(typeOfReference) {
      case TAnonymous(anon):
        for (field in anon.get().fields) {
          fieldsToCheck.push(field.name);
        }
      case TType(type, _):
        switch(type.get().type) {
          case TAnonymous(typeanon):
            for ( field in typeanon.get().fields) {
              fieldsToCheck.push(field.name);
            }
          default:
            throw new Error('Could not extract TAnonymous from $typeOfReference!', reference.pos);
        }
      default:
        throw new Error('Expected TAnonymous instead of $typeOfReference!', reference.pos);
    }

    for (field in fieldsToCheck) {
      conds.push( { expr : EBinop(OpEq,
                    { expr : EField(reference, field.toString()) , pos : curPos},
                    { expr : EField(shouldHave, field.toString()), pos : curPos})
                  , pos : curPos} );
    }
    
    function makeAnd(conds:Array<Expr>):Expr {
      var elem = conds.pop();
      if (conds.length == 0)
        return elem;
      else
        return { expr : EBinop(OpBoolAnd, elem, makeAnd(conds)), pos : curPos};
    }
    
    return makeAnd(conds);
  }
}
```

## Usage

```haxe
import CompareMacro;

class Main {
  static function main() {
    CompareMacro.matchAllFromAnon(
      { valA:1, valB:2},
      { a:0, b:5, valA:1, valB:2}
    ); // true
  }
}
```
