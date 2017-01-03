[tags]: / "enum,pattern-matching,functional-programming"

# Enums as GADTs

As [already established](http://code.haxe.org/category/beginner/enum-adt.html) Haxe enums are a form of algebraic data types. In fact, they may even serve as so called "*generalized* algebraic data types" - GADTs for short. While for an "ordinary" enum every constructor yields the same type, with an GADT each constructor may yield a different type. 

To illustrate that, let's define a little language for arithmetic expressions:

```haxe
enum Expr<T> {
  Sum(a:Expr<Float>, b:Expr<Float>):Expr<Float>; 
  Product(a:Expr<Float>, b:Expr<Float>):Expr<Float>;
  Power(a:Expr<Float>, b:Expr<Float>):Expr<Float>; // <-- this constructor returns an Expr<Float> ...
  
  GreaterThan(a:Expr<Float>, b:Expr<Float>):Expr<Bool>;// <-- ... and this one an Expr<Bool>
  Not(a:Expr<Bool>):Expr<Bool>;
  Or(a:Expr<Bool>, b:Expr<Bool>):Expr<Bool>;
  And(a:Expr<Bool>, b:Expr<Bool>):Expr<Bool>;
  
  Const(v:T):Expr<T>;
  Equals<O>(a:Expr<O>, b:Expr<O>):Expr<Bool>;
}
```

So now we can say: I want a numeric expression or a boolean one, by either saying `Expr<Float>` or `Expr<Bool>`.

The last two constructors in the example are particularly interesting:

- `Const` may accept a value of any type and becomes and `Expr` of that type. 
- `Equals` has a type parameter. This is actually not GADT specific. Ordinary enum constructors may have this too, because at the bottom line they are functions and may therefore be parametrized. In the case of `Equals` it is the type of the `Expr` being compared. It is arbitrary, but still must be equal for both operands and the result will always be boolean. This models very closely how `==` works.

For example `1.0 + 1.0 == 2` could be written as `Equals(Sum(Const(1.0), Const(1.0)), Const(2.0))` and will compile, as opposed to `Equals(Const(3.14), Const('test'))` which will fail with `String should be Float` exactly as `3.14 == 'test'`. 

The compiler performs the desired type checks when constructing GADTs. It does the same when deconstructing them. 

To see that in action, let's have a look at how we would evaluate a numeric expression:

```haxe
function valueOf(f:Expr<Float>):Float {
  return switch f {
    case Const(v): v;
    case Sum(a, b): valueOf(a) + valueOf(b);
    case Product(a, b): valueOf(a) * valueOf(b);
    case Power(a, b): Math.pow(valueOf(a), valueOf(b));
  }
}
```

That's it already. Try omitting any constructor that can return `Expr<Float>` (which does include `Const` for which that is just a special case) and Haxe's exhaustiveness check will tell you a case is not covered. Check against a constructor that is `Expr<Bool>` and Haxe will tell you this:
  
> `Expr<Bool>` should be `Expr<Float>`  
> Type parameters are invariant  
> `Bool` should be `Float`  

So if we pick the type parameter, Haxe will reduce the number of cases for us. If we leave the parameter unbound, we must treat all cases:
  
```haxe
function eval<V>(e:Expr<V>):V {
  return switch e {
    case Const(v): 
      $type(e); // Expr<eval.V>
      v;
    case Sum(a, b): 
      $type(e); // Expr<Float>
      eval(a) + eval(b);
    case Product(a, b): 
      eval(a) * eval(b);
    case Power(a, b): 
      Math.pow(eval(a), eval(b));
    case GreaterThan(a, b): 
      eval(a) > eval(b);
    case Equals(a, b): 
      $type(e); // Expr<Bool>
      $type(a); // Expr<Equals.O>
      eval(a) == eval(b);
    case Not(a): 
      !eval(a);
    case Or(a, b): 
      eval(a) || eval(b);
    case And(a, b): 
      eval(a) && eval(b);
  }
}
```

Notice how in each case `Expr.T` may assume a different type. In the first case it remains unbound, in the second it becomes `Float` and further below it is `Bool`. Try returning `5` in the first case and the compiler will tell you `Int` should be `eval.V`.

All in all, this is a very powerful feature, capable of expressing extremely complex type structures.
