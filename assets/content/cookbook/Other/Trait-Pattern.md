[tags]: / "static-extension"

# A Trait Pattern

Haskell has typeclasses, Rust has traits.  Both provide a way to extend a type with a large number of methods that depend on just a few user-specified properties.  Additionally, systems that support the trait-like pattern allow the same underlying type to be extended by multiple unrelated traits.

You can emulate the trait-like pattern  in Haxe using  interfaces, static extensions, and the @:using metadata.

## An example:

The following defines a "trait" for things that have a name. 

```haxe
// HasName.hx

@:using(HasName.HasNameExt)
interface HasName {
    var firstName:String;
    var lastName:String;
}

class HasNameExt {

    public static function fullName(ob:HasName):String {
        return '${ob.firstName} ${ob.lastName}';
    }

}

```

With the above, any class that implements `HasName` will automatically have a
`fullName` method defined for it.

Similarly, here is a trait defining things that age:

```haxe
// HasAge.hx

@:using(HasAge.HasAgeExt)
interface HasAge {
    var age:Int;
}

class HasAgeExt {

    public static function birthday(ob:HasAge):Int {
        ob.age += 1;
        return ob.age;
    }

}

```

## Using the "traits"

To bring it all together, write a `Person` class that implements each of above interfaces:

```haxe
// Person.hx

class Person
implements HasName
implements HasAge {

    public var firstName:String;
    public var lastName:String;

    public var age:Int;

    public function new (f,l,a) {
        this.firstName = f;
        this.lastName = l;
        this.age = a;
    }

    public static function main () {
        var person = new Person("Bob", "Jones", 88);
        trace('${person.fullName()} is ${person.age} years old');
        person.birthday();
        trace('${person.fullName()} is now ${person.age} years old');
    }

}

```

This example was highly contrived, but hopefully you can see how you
might extend the idea in your own real code.


