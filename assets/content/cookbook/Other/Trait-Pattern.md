[tags]: / "static-extension"

# An Automatic Interface Implementation Pattern

Interfaces are cool because they let us tell the compiler about a relationship between classes that we can rely on when designing programs.  However, it kind of stinks that we can't include method implementations in an interface declaration.

Not to worry, Haxe has you covered. By using interfaces, static extensions, and the @:using metadata, you can implement functions that are automatically available for all implementors of your interface.

## An example:

The following defines an interface for things that have a name. 

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

Similarly, here is an interface defining things that age:

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

> Author: [Colin Okay](https://github.com/cbeo)

