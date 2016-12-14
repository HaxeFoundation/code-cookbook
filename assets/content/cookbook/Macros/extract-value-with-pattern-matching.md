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

	
}
```

## Usage

```haxe
package;

enum Tree<T> {
  Leaf(v:T);
  Node(l:Tree<T>, r:Tree<T>);
}

class MatchTest{

	static function assert(v, ?pos : haxe.PosInfos) if (!v) throw 'Assert failed. ' + pos;
	
	static function main() {
		//Enum matching
		assert("leaf0" == Match.extract(Leaf("leaf0"), Leaf(name)));
		assert("leaf1" == Match.extract(Node(Leaf("leaf0"), Leaf("leaf1")), Node(_, Leaf(leafName))));
		
		var result = Match.extract(Node(Leaf("leaf0"), Leaf("leaf1")), Node(Leaf(leafName0), Leaf(leafName1)));
		assert("leaf0" == result.leafName0);
		assert("leaf1" == result.leafName1);
		
		//Structure matching
		var myStructure = {
			name: "haxe",
			rating: "awesome"
		};
		assert("haxe" == Match.extract(myStructure, {name:name}));
		var result = Match.extract(myStructure, {name:n, rating:r});
		assert("haxe" == result.n);
		assert("awesome" == result.r);
		
		//Array matching
		var myArray = [1, 6];
		assert(6 == Match.extract(myArray, [1, a], 0)); // 0 is return value if pattern don't match, if not specified it's null
		
		//Or patterns, Extractors
		assert(6 == Match.extract(7, (6 => a) | (7 => a)));
		
		//Guards - not supported due to haxe macro syntax limitations
		//var result = Match.extract(myArray, [a, b] if a < b);
		//assert(result.a == 1 && result.b == 6);
		
		//Match on multiple values
		//have to force type to Array<Dynamic> to make it work, looks ugly
		var result = Match.extract(([1, false, "foo"]:Array<Dynamic>), [a, b, c]);
		assert(result.a == 1 && result.b == false && result.c == "foo");
		
		//throw if not match
		try {
			Match.extract(Leaf(0), Node(_ => firstLeaf, _), throw 'no match');
			assert(false);
		}
		catch (_:Dynamic) {
		}
		
		trace('ok');
	}
	
}
```
