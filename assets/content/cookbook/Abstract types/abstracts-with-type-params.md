[tags]: / "abstract-type,type-params,extern"

# Strict typing for stringly-typed extern code

A common pattern, often found in (but not only in) dynamic languages, is to denote the type of some object
with a string, for example:

```haxe
// the actual `listener` function arguments depend on the `eventName`
function addEventListener(eventName:String, listener:Function):Void;

// the returned value depends on `property`
function getProperty(property:String):Dynamic;

// the expected `value` value depends on `property`
function setProperty(property:String, value:Dynamic):Void;
```

For the Haxe code, this is considered a bad pattern, since it doesn't provide compile-time type checking and thus is unsafe.
There are ways to do this safer, for example leveraging [ADT (enums)](http://haxe.org/manual/types-enum-instance.html),
however we often need to provide extern definitions for some code that follows this pattern.

Good news are - with Haxe we can stay type-safe by using type parameters and abstracts!

Let's examine the `setProperty` example from the code above.


## Step 1. Proper typing of string values

Step 1 is to define a concrete type for our `property` argument, so we can't pass arbitrary string to it.
But at run-time a string is still expected, so our type should be represented as strings at run-time, which is
exactly what [abstract types](http://haxe.org/manual/types-abstract.html) are for:

```haxe
abstract Property(String) {
  public inline function new(name) {
    this = name;
  }
}
```

Then, let's change the `property` argument type to our new `Property` abstract type:

```haxe
function setProperty(property:Property, value:Dynamic):Void;
```

This already provides some compile-time safety because we need to have values of the `Property` type,
not plain `String`, so we can't confuse it with other strings:

```haxe
var playerName = new Property("playerName"); // this could be some inlined constant

setProperty(playerName, "Dan");

// won't compile: String should be Property
// setProperty("whatever", "Dan");
```

However we still can pass any value as the `value` argument, since it's typed `Dynamic`.


## Step 2. Binding value type to a property name

We want to associate our `Property` values with a concrete type for this property value.
This is where [type parameters](http://haxe.org/manual/type-system-type-parameters.html) come into play.

Let's parametrize our `Property` abstract type so its instances carry information about value type:

```haxe
abstract Property<T>(String) { // note the T type parameter
  public inline function new(name) {
    this = name;
  }
}
```

Now we can create "property" values specifying types of corresponding values, like this:

```haxe
// the value stored in playerName is String
var playerName = new Property<String>("playerName");

// playerLevel values are Int
var playerLevel = new Property<Int>("playerLevel");

// the info property is an object with given fields
var info = new Property<{age:Int, dead:Bool}>("info");
```

Looks descriptive, but useless until we implement step 3.


## Step 3. Using type parameter in a function

Finally, let's make use of that type parameter `T` in our `setProperty` function.
For that we also parametrize the function and use the type parameter for the value instead of `Dynamic`:

```haxe
function setProperty<T>(property:Property<T>, value:T):Void;
```

Note that we use the type `T` for both `value` and a type parameter for the `Property` abstract, which
ensures that they are the same.

Now we can call our parametrized function with properly-typed property names and get type-checking for values.

## Full example

Here's an example of extern class for some database object that supports `getProperty` and `setProperty`:

```haxe
extern class Database {
  function new();
  function getProperty<T>(property:Property<T>):T;
  function setProperty<T>(property:Property<T>, value:T):Void;
}

abstract Property<T>(String) {
  public inline function new(name) {
    this = name;
  }
}
```

And an example usage:

```haxe
class Main {
  static inline var PLAYER_NAME = new Property<String>("playerName");
  static inline var PLAYER_LEVEL = new Property<Int>("playerLevel");

  static function main() {
    var db = new Database();

    // playerName variable will be typed as String
    var playerName = db.getProperty(PLAYER_NAME);
    trace(playerName.toUpperCase());

    // works: expected value is Int
    db.setProperty(PLAYER_LEVEL, 1);

    // compile error: String should be Int
    // db.setProperty(PLAYER_LEVEL, "not an int");
  }
}
```

Let's look at the main function compiled to JavaScript to see what it translates to:

```js
var db = new Database();
var playerName = db.getProperty("playerName");
console.log(playerName.toUpperCase());
db.setProperty("playerLevel",1);
```

## Typed event listeners example

In the beginning of this article we also mentioned the `addEventListener` function, so for the sake of completeness, let's also apply our new knowledge to it. Here, we use type parameter to specify listener function type:

```haxe
import haxe.Constraints.Function;

abstract Event<T:Function>(String) {
  public inline function new(name) {
    this = name;
  }
}

extern class EventEmitter {
  function new();
  function addEventListener<T:Function>(event:Event<T>, listener:T):Void;
}

class Main {
  static inline var EVENT_START = new Event<Array<String>->Void>("start");
  static inline var EVENT_EXIT = new Event<Int->Void>("exit");

  static function main() {
    var emitter = new EventEmitter();

    // arr is inferred as Array<String>
    emitter.addEventListener(EVENT_START, function(arr) trace(arr));

    // compile error: String -> Void should be Int -> Void
    // emitter.addEventListener(EVENT_EXIT, function(s:String) {});
  }
}
```

Note how we also constrained our type parameter to the `haxe.Constraints.Function` which makes sure that we can only specify function types as event type parameter.

> Author: [Dan Korostelev](https://github.com/nadako)
