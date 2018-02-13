[tags]: / "functional programming, ADT, enum, parsing"

# ML-Style Parse Tree Evaluation

ML-like languages are great for creating interpreters or compilers, by virtue of Algebraic Data Types.
Haxe's `enum` allow for writing similarly elegant code.

Below is the Haxe version of F# code for a simple expression interpreter, described in [Programming Language Concepts](https://github.com/steshaw/plc-sestoft) (Sestoft). 

## Implementation

The `eval` function uses pattern matching against an expression, represented by a parametized enum data data type. 
```haxe
class Main {
  /** 
    The eval function uses pattern matching against an expression, 
    represented by a parametized enum data data type. 
  **/
  static public function eval(e:Expr):Int {
    switch e {
      case CstI(x) : return x;
      case Prim("+", e1, e2): return eval(e1) + eval(e2) ;
      case Prim("-", e1, e2): return eval(e1) - eval(e2) ;
      case Prim("*", e1, e2): return eval(e1) * eval(e2) ;
      case Prim(_) : throw "Unknown primitive";
    }
  }
 
    // Some simple tests.
  static public function main():Void {

    // Evaluate the expression 23.
    trace( eval( CstI(23) ) );

    // Evaluate the expression (7 * 9) + 10.
    trace( eval( Prim("+", Prim("*", CstI(7), CstI(9)), CstI(10)) ) );
  }
}

/*  Algabreic Data Type for an arithmetic expression. In F# would be:
    type expr = 
      | CstI of int
      | Prim of string * exp * exp 
*/
enum Expr {
  CstI( x:Int );  // An integer constant
  Prim( op:String, e1:Expr, e2:Expr ); // Or a primary arithmetic expression
}
```

> Author: [Yves Cloutier](https://github.com/cloutiy)
