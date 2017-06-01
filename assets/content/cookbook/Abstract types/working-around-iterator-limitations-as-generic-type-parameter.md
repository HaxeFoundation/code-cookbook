[tags]: / "abstract-type,type-params,iterator"

# Using Iterators as Generic Type Parameters

[Iterators](https://haxe.org/manual/lf-iterators.html) are a helpful Haxe structure. Any structure that implements the next and hasNext functions with the appropriate signature will allow you build a for loop. Arrays have an iterator() function that returns exactly this, and you don't need to call it, the for language construction does it for you.

Consider, however, the case where you would like iterate over an array of items over time, not just iterate all over them in strict sequence. Say that you are implementing a videogame. The videogame has an update loop, and you need to iterate over an array on each tick, instead of iterating it all over one tick. We wish to implement a turtle trainer, and we express a turtle using an enum ([they're really powerful](http://code.haxe.org/category/beginner/enum-adt.html)). Said enum will have just a name to identify a turtle. You can copy and paste this code in [Try Haxe](https://try.haxe.org/).

```haxe
enum Turtles {
  A_TURTLE(name:String);
}

class Test {
  static function main() {
    var exitRequested = false;
    var turtles = [A_TURTLE("Leonardo"), A_TURTLE("Raphael"), A_TURTLE("Michelangelo"), A_TURTLE("Donatello")];
    var turtleIt = turtles.iterator();
    do {
      exitRequested = updateLoop(turtleIt);
    } while (!exitRequested);
  }
  
  // Returns true if player requests to exit the game or if we ran out of turtles
  public static function updateLoop(turtleIt) : Bool {
    if (!turtleIt.hasNext()) {
      return true;
    }
    var nextTurtle = turtleIt.next();
    switch (nextTurtle) {
      case A_TURTLE(name): trace("Training the next turtle: " + name);
    }
    return false;
  }
}
```

This code will compile and run without problems. The compiler will deduce correctly that the turtleIt parameter in updateLoop() is an iterator. Notice we need the switch to match the name and extract it from the enum, even if there is only one enum value. Running it will produce the following output:

```
Training the next turtle: Leonardo
Training the next turtle: Raphael
Training the next turtle: Michelangelo
Training the next turtle: Donatello
```

But what if it was all turtles all the way down? We could have not just an array of turtles, but we could have turtles built out of turtles! Whenever we step on these multi-part turtles, we will just train each one of them as if they were a single turtle.

We also need to remember which was the turtle we were training after we deal with the complex one. This calls for having a stack of iterators. The initial array iterator will be the first one that will be pushed. Whenever we find a complex turtle, let's push the iterator onto the stack. After we finish the complex turtle, pop it back and continue with the previous iterator. Haxe has a [GenericStack](http://api.haxe.org/haxe/ds/GenericStack.html) in its API, so let's use it. 

Let's add a new value in our enum type.

```haxe
import haxe.ds.GenericStack;

enum Turtles {
  A_TURTLE(name:String);
  MANY_TURTLES(turtles:Array<Turtles>);
}

class Test {
  static function main() {
    var exitRequested = false;
    var turtles = [A_TURTLE("Leonardo"), MANY_TURTLES([A_TURTLE("Raphael1"), A_TURTLE("Raphael2")]), A_TURTLE("Michelangelo"), A_TURTLE("Donatello")];
    var turtleIt = turtles.iterator();
    var turtleStack = new GenericStack<Iterator<Turtles>>();
    turtleStack.add(turtleIt);
    do {
      exitRequested = updateLoop(turtleStack);
    } while (!exitRequested);
  }
  
  // Returns true if player requests to exit the game or if we ran out of turtles
  public static function updateLoop(turtleStack) : Bool {
    if (turtleStack.isEmpty()) {
      return true;
    }
    var nextTurtleIterator = turtleStack.first();
    if (nextTurtleIterator.hasNext()) {
      switch (nextTurtleIterator.next()) {
        case A_TURTLE(name): trace("Training the next turtle: " + name);
        case MANY_TURTLES(turtles): turtleStack.add(turtles.iterator());
      }
    } else {
      turtleStack.pop();
    }
    return false;
  }
}
```

Running this code will produce the following output:

```
Training the next turtle: Leonardo
Training the next turtle: Raphael1
Training the next turtle: Raphael2
Training the next turtle: Michelangelo
Training the next turtle: Donatello
```

Notice how comfortable is to work with enums. A new value in the enum means that the compiler will complain on all the switch blocks that deal with this enum type and have no default case. Is this annoying? Yes, very, at first. But we definitely want the compiler to catch errors for us as early as possible. Forgetting to add an enum case is a frequent mistake, so prefer not using default whenever you work with switches, it will save you a lot of time when you maintain your code.

This code will also work in [Try Haxe](https://try.haxe.org/). But notice that it only works with the Javascript target as it is. Try changing the Target option in Try Haxe by going to the Options tab, and clicking on SWF. Now compile it again. The compiler will now complain with the following output:

```
Build failure
Test.hx:13: characters 26-57 : Type parameter must be a class or enum instance (found { next : Void -> Turtles, hasNext : Void -> Bool })
```

What happened? Turns out that only types can be used as parameters, and an Iterator is a structure. This is a limitation when you want to use it as the parameter for a generic type.

Javascript is quite flexible and is able to accept a structure as a type parameter quite happily, but it is not the same case for most of the rest of the targets. The cpp target, for instance, will complain the same way as it did for the swf target.

You could try *typedef*ing the Iterator, as follows:

```haxe
typedef TurtleIterator = Iterator<Turtle>;

// replace var turtleStack = new GenericStack<Iterator<Turtles>>();
// for     var turtleStack = new GenericStack<TurtleIterator>();
```

You will still get the same compiler error in the swf target. The Haxe compiler considers that Iterator is still a structure for type parameter purposes, and not a class or enum instance. You could write a class that wraps an Iterator, even parametize it; but it means writing a lot of unnecesary boilerplate code.

This is when an abstract type is the perfect wrapper, and it's just 5 lines of code (assuming braces do not belong in a newline, your call):

```haxe
@:forward(hasNext, next)
abstract AbstractIterator<T>(Iterator<T>) {
  inline public function new(iterator:Iterator<T>) {
    this = iterator;
  }
}
```

[Abstract classes](https://haxe.org/manual/types-abstract.html) are quite unlike abstract classes in other well-known languages. They modify or augment a concrete type, acting as a compile-time type, but the compiler implements them as their underlying type for the target language.

In other words, abstract types are simply a way of specializing a type. For the purposes of the compiler, it's a type, but at the moment of generating the target code, the wrapper is discarded and it generates the same code as it would for the wrapped type. In this case, we are wrapping the Iterator, and we're also forwarding the two methods of Iterator, hasNext and next, instead of rewriting them as inline public functions. We can now use AbstractIterator as a parameter for the GenericStack.

```haxe
import haxe.ds.GenericStack;

@:forward(hasNext, next)
abstract AbstractIterator<T>(Iterator<T>) {
  inline public function new(iterator:Iterator<T>) {
    this = iterator;
  }
}

typedef TurtleIterator = AbstractIterator<Turtles>;

enum Turtles {
  A_TURTLE(name:String);
  MANY_TURTLES(turtles:Array<Turtles>);
}

class Test {
  static function main() {
    var exitRequested = false;
    var turtles = [A_TURTLE("Leonardo"), MANY_TURTLES([A_TURTLE("Raphael1"), A_TURTLE("Raphael2")]), A_TURTLE("Michellangelo"), A_TURTLE("Donatello")];
    var turtleIt = turtles.iterator();
    var turtleStack = new GenericStack<TurtleIterator>();
    turtleStack.add(new TurtleIterator(turtleIt));
    do {
      exitRequested = updateLoop(turtleStack);
    } while (!exitRequested);
  }
  
  // Returns true if player requests to exit the game or if we ran out of turtles
  public static function updateLoop(turtleStack:GenericStack<TurtleIterator>) : Bool {
    if (turtleStack.isEmpty()) {
      return true;
    }
    var nextTurtleIterator = turtleStack.first();
    if (nextTurtleIterator.hasNext()) {
      switch (nextTurtleIterator.next()) {
        case A_TURTLE(name): trace("Training the next turtle: " + name);
        case MANY_TURTLES(turtles): turtleStack.add(new TurtleIterator(turtles.iterator()));
      }
    } else {
      turtleStack.pop();
    }
    return false;
  }
}
```

Remember this is only necessary if you are targeting a static target (cpp, Java, etc.), rather than a dynamic target, but it also shows you the power of abstract types in Haxe, and how could you use them to specialize basic types.
