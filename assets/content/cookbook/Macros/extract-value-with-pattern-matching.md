[tags]: / "enum,pattern-matching,macro-function"

# Extract values with pattern matching 

Mostly useful to extract enum values from known enum instances. Allows to extract multiple variables at once. 
Takes most of expressions that are possible to use in switch expression.

## Implementation

```haxe
package;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class Match {
	
	public static macro function extract(value:Expr, pattern:Expr, ?ifNot:Expr) {
		var params = [];
		function getParamNames(expr:ExprDef) {
			switch(expr) {
				case EConst(CIdent(name)) | EBinop(OpArrow, _, {expr:EConst(CIdent(name))}): if (name != '_' && params.indexOf(name) < 0) params.push(name);
				case ECall(_, params): for (param in params) getParamNames(param.expr);
				case EBinop(OpArrow, _, expr): getParamNames(expr.expr);
				case EBinop(OpOr, expr0, expr1): getParamNames(expr0.expr); getParamNames(expr1.expr);
				case EObjectDecl(fields): for (field in fields) getParamNames(field.expr.expr);
				case EArrayDecl(values): for (value in values) getParamNames(value.expr);
				case EParenthesis(expr): getParamNames(expr.expr);
				default:
			}
		}
		getParamNames(pattern.expr);
		
		var resultExpr = switch(params.length){
			case 1: macro $i{params[0]};
			case _: {expr:EObjectDecl(params.map(function(paramName) return {field:paramName, expr:macro $i{paramName}})), pos:Context.currentPos()};
		}
		
		return macro {
			switch($value) {
				case $pattern: $resultExpr;
				case _: $ifNot;
			}
		};
	}

	
}```

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
