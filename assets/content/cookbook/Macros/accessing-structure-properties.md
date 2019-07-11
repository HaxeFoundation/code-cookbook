[tags]: / "expression-macro"

# Accessing structures properties

Complementing [Combine two or more structures](combine-objects.html) which shows how to implement a `combine()` method to mix structure values, here we create three more methods to list structure properties, and get/set its values. It's used the same way as mentioned and it makes sense to have them all in the same utility class:

## Implementation

```haxe
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.Tools;
using Lambda;
#end

class StructureTools {

  /** return the object's propery names as array of strings */
	public static macro function props(rest:Array<Expr>):Expr {
	 var propsNames = [];
    var selfType = Context.typeof(self);
    switch (selfType.follow()) {
      case TAnonymous(_.get() => tr):
        for (field in tr.fields) {
          propsNames.push(field.name);
        }	
      default:
        return Context.error("Object type expected instead of " + selfType.toString(), self.pos);
    }
		var propsStringLiterals = propsNames.map(function(name) {
      return {
        expr: EConst(CString(name)), 
        pos: Context.currentPos()
      }
    });
		var arrDecl:Expr = {
      expr: EArrayDecl(propsStringLiterals), 
      pos: Context.currentPos()
    };
		return macro $b{[macro $arrDecl]};
	}

  /** sets property of given name to given value */
	public static macro function set(self:ExprOf<Dynamic>, name:String, value:Expr) {
		return {
			expr: EBinop(OpAssign, {  
				expr: EField(macro ${self}, name),
				pos: Context.currentPos()
			}, macro ${value}),
			pos: Context.currentPos()
		};
	}

  /** gets given property value */
	public static macro function get(self:ExprOf<Dynamic>, name:String) {
		return {
      expr: EField(macro ${self}, name),
      pos: Context.currentPos()
    };
	}
}
```

## Usage

You can import the macro class with `using`.

```haxe
using StructureTools;

class Main {
	static function main() {
		var a = {
			foo: 1,
			bar: "hello"
		};
		var b = {
			bar: "he"
		};
		trace(a.get("foo") + ", " + a.get("bar") + ", " + a.props() + ", " + b.props());
		a.set("foo", 2);
		a.set("bar", "world");
		trace(a.get("foo") + ", " + a.get("bar") + ", " + a.props());
	}
}
```

Compiling the code generates something like the following (simplification from JavaScript output):

```
	var a_foo = 1;
	var a_bar = "hello";
	var b_bar = "he";
	trace(a_foo + ", " + a_bar + ", " + Std.string(["bar","foo"]) + ", " + Std.string(["bar"]));
	a_foo = 2;
	a_bar = "world";
	ttrace(a_foo + ", " + a_bar + ", " + Std.string(["bar","foo"]));  
```

Notice Notivide how properties are inlined at compile time and only those properties present on the object. Also notice how `set()` just generates a assignament statement and how `get()` generates a field access expression. 

Also notice that it was not our macro but the compiler optimizations that replaced objects properties with plain variables. 

the statement `fb = {a: 111}.combine({b:13.1}, {bar: "happy hour"});` generates code like: `fb = {a: 111, b: 13.1, bar: "happy hour"};`. As you can see, the output code's variable declarations are assigned to values which are *already mixed* (at compile time).
> Author: [Sebastián Gurin](https://github.com/cancerberosgx)
