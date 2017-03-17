[tags]: / "expression-macro,validation"

# Assert macro that shows sub-expression values

Sometimes failed assertion checks make it difficult to tell what went wrong. For debugging the programmer not only wants to know
*that* a check failed, but also *why* it failed. This macro outputs the values of all sub-expressions.

```haxe
import haxe.macro.Expr;
using haxe.macro.Tools;

class Assert {
  static public macro function assert(e:Expr) {
    var s = e.toString();
    var p = e.pos;
    var el = [];
    var descs = [];
    function add(e:Expr, s:String) {
      var v = "_tmp" + el.length;
      el.push(macro var $v = $e);
      descs.push(s);
      return v;
    }
    function map(e:Expr) {
      return switch (e.expr) {
        case EConst((CInt(_) | CFloat(_) | CString(_) | CRegexp(_) | CIdent("true" | "false" | "null"))):
          e;
        case _:
          var s = e.toString();
          e = e.map(map);
          macro $i{add(e, s)};
        }
    }
    var e = map(e);
    var a = [for (i in 0...el.length) macro { expr: $v{descs[i]}, value: $i{"_tmp" + i} }];
    el.push(macro if (!$e) @:pos(p) throw new Assert.AssertionFailure($v{s}, $a{a}));
    return macro $b{el};
  }
}

private typedef AssertionPart = {
  expr: String,
  value: Dynamic
}

class AssertionFailure {
  public var message(default, null):String;
  public var parts(default, null):Array<AssertionPart>;
  public function new(message:String, parts:Array<AssertionPart>) {
    this.message = message;
    this.parts = parts;
  }

  public function toString() {
    var buf = new StringBuf();
    buf.add("Assertion failure: " + message);
    for (part in parts) {
        buf.add("\n\t" + part.expr + ": " + part.value);
    }
    return buf.toString();
  }
}
```

## Usage


```haxe
class Main {
    static function main() {
        //Error: Assertion failure: x == 7 && y == 11
        //x: 7
        //x == 7: true
        //y: 10
        //y == 11: false
        //x == 7 && y == 11: false
        var x = 7;
        var y = 10;
        Assert.assert(x == 7 && y == 11);
        
        //Error: Assertion failure: a.length > 0
        //a: []
        //a.length: 0
        //a.length > 0: false
        var a = [];
        Assert.assert(a.length > 0);
    }
}
```

> Inspired by <https://github.com/sconover/wrong>  
> Author: [Simn](https://github.com/simn)
