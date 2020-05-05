# Method chaining / Fluent interface 

This is an example of the [Method chaining](https://en.wikipedia.org/wiki/Method_chaining) design pattern in Haxe.

Method chaining is calling a method of an object that return the same type of the object multiple times.

One example is jQuery:

```
$("p.neat").addClass("ohmy").show("slow");
```

A class that let us do method chaining is having a fluent interface.

Fluent interface isn’t very good to be used in a strongly typed OOP language without careful consideration. 
Why? For example, if we want to extend TweenLiteVars to have one more property called “awesome”, and use it:

```haxe
var vars:MyTweenLiteVars = 
  new MyTweenLiteVars()
    .prop("x", 300) //prop() returns TweenLiteVars, not MyTweenLiteVars
    .awesome(true)  //compiler error, TweenLiteVars does not have awesome :(
    .autoAlpha(0)
    .onComplete(myFunction, [mc]);
```

Method chaining is broken, not so awesome.
There is no elegant way to do it properly in several languages. 

In Haxe it can be done using generic types. All we have to do is to create a base class, for example:

```haxe
class Component<This:Component<This>> {
  public function clone():This {
    return throw "Needs to be overrided";
  }
}

class NormalComponent extends Component<NormalComponent> {
  public function new() {
    
  }

  override public function clone():NormalComponent {
    return new NormalComponent();
  }
}
```

People now can extend Component and have `clone()` properly typed as the subclass:

```haxe
/*
 * When a SpecialComponent is cloned, there is some chance it gives birth to a unicorn(!).
 */
class SpecialComponent extends Component<SpecialComponent> {
  public var hasHorn(default, null):Bool;

  public function new() {
    super();
    hasHorn = false;
  }

  override public function clone():SpecialComponent {
    var newComponent = new SpecialComponent();
    newComponent.hasHorn = Math.random() > 0.8;
    return newComponent;
  }
}
```

Here is an example of using the above Component classes:

```haxe
class Main { 
  static function main() {
    var NormalComponent = new NormalComponent();
    trace("A clone of NormalComponent is..." + Type.getClassName(Type.getClass(NormalComponent.clone())));
    trace("What about a SpecialComponent? Let see...");

    var SpecialComponent = new SpecialComponent();
    while (true) {
      if (SpecialComponent.hasHorn) {
        trace("This SpecialComponent has a horn! It's a unicorn!");
        break;
      } else {
        trace("This SpecialComponent looks like a normal one. Let's clone it...");
        SpecialComponent = SpecialComponent.clone();
      }
    }
  } 
}
```

Sample output of above:

```
Main.hx:4: A clone of NormalComponent is...NormalComponent
Main.hx:7: What about a SpecialComponent? Let see...
Main.hx:15: This SpecialComponent looks like a normal one. Let's clone it...
Main.hx:15: This SpecialComponent looks like a normal one. Let's clone it...
Main.hx:12: This SpecialComponent has a horn! It's a unicorn!
```

But of course, if you want to extend SpecialComponent, it suffers the same problem, unless you turn SpecialComponent into a base abstract class too.

```haxe
class SpecialComponent<This:SpecialComponent<This>> extends Component<This> {
  public var hasHorn(default, null):Bool;

  private function new() {
    super();
    hasHorn = false;
  }

  override public function clone():This {
    return throw "needs to be overrided";
  }
}
```

> Source: <https://blog.onthewings.net/2010/12/19/method-chaining-and-fluent-interface-in-haxe/>

> Author: [andyli](https://github.com/andyli)

Happy chaining!