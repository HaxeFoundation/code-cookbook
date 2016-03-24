# Null safety

Haxe doesn't provide built-in null-safety, however it's possible to write null-safe code without run-time overhead
using abstract similar to the following:

```haxe
abstract Maybe<T>(Null<T>) from Null<T> {

  public inline function exists():Bool {
    return this != null;
  }

  public inline function sure():T {
    return if (exists()) this else throw "No value";
  }

  public inline function or(def:T):T {
    return if (exists()) this else def;
  }

  public inline function may(fn:T->Void):Void {
    if (exists()) fn(this);
  }

  public inline function map<S>(fn:T->S):Maybe<S> {
    return if (exists()) fn(this) else null;
  }

  public inline function mapDefault<S>(fn:T->S, def:S):S {
    return if (exists()) fn(this) else def;
  }
}
```

## Usage

```haxe
class Test {
  static function main() {
    // initialize from null...
    var value:Maybe<Int> = null;
    // ...or a value of underlying type
    value = 10;

    // compilation errors, so you can't use Maybe<T> without explicit unwrapping
    // var v:Int = value;
    // var v = value + 5;

    // get value or raise exception
    var v = value.sure();

    // get value or use default
    var v = value.or(0);

    // check whether value exists
    if (value.exists())
        trace("value exists!");

    // execute function if value exists
    value.may(function(value) trace("Value is " + value));

    // map value to Maybe<String>
    var valueString = value.map(function(value) return Std.string(value));

    // map value to String or use default string
    var message = value.mapDefault(function(value) return "Value is " + value, "No value");
  }
}
```
