[tags]: / "enum, data-structures"

# Using enum / ADT

Haxe's enumeration types are algebraic data types. Their primary use is for describing data structures.

### Creation

#### Defining an enum

Enums are denoted by the `enum` keyword and contain one or more enum constructors. Enum constructors can contain an arbitrary number of constructor arguments.

```haxe
// Describes a type of item that can be rewarded
enum ItemType {
  Key;
  Sword(name:String, attack:Int);
  Shield(name:String, defense:Int);
}

// Describes a type of reward that can be given
enum RewardType {
  Gold(value:Int);
  Experience(value:Int);
  Item(type:ItemType);
}
```

#### Creating an enum instance

To create an enum instance, call its constructor.

```haxe
var gold = RewardType.Gold(123);
var experience = RewardType.Experience(456);
var item = RewardType.Item(ItemType.Key);
```

Alternatively, instantiate the enum via methods from `haxe.EnumTools`. Read more about it in the [Tooling](#enumtools) section.

```haxe
// Creates Sword item type with name Slashy and strength 100
var createdByName = ItemType.createByName("Sword", ["Slashy", 100]);
// Creates Key item type, as it is the first constructor specified
var createdByIndex = ItemType.createByIndex(0);
``` 

###  Usage

Values passed to enum constructors can be obtained through pattern matching.

```haxe
var reward = RewardType.Item(ItemType.Sword("Slashy", 100));

switch(reward) {
  case RewardType.Gold(value):
    trace('I got $value gold!');
  case RewardType.Experience(value):
    trace('I got $value experience!');
  case RewardType.Item(type):
    switch(type) {
      case ItemType.Key:
        trace('I got a key!');
      case ItemType.Sword(name, attack):
        trace('I got "$name", a sword with $attack attack!');
      case ItemType.Shield(name, defense):
        trace('I got "$name", a shield with $defense defense!');
    }
}

// Output: I got "Slashy", a sword with 100 attack!
```

### Tooling

#### EnumTools

The `haxe.EnumTools` module in the standard library contains several methods to help work with enums and enum constructors. They provide additional ways to create enum instances, as well as obtain information on enum constructors.

These methods are automatically included in the module context when using enums, but usually they would be included explicitly through `using haxe.EnumTools;`.

Some examples are presented below:

```haxe
// Gets enum name, including path
var enumName = ItemType.getName();
// Gets array of constructor names for provided enum
var enumConstructorNames = ItemType.getNames();
```

#### EnumValueTools

The `haxe.EnumValueTools` module in the standard library contains several methods to help work with enum values. They provide additional ways to compare enum instances, and get their constructors and constructor arguments.

These methods are automatically included in the module context when using enums, but usually they would be included explicitly through `using haxe.EnumValueTools;`.

Some examples are presented below:

```haxe
var item = ItemType.Shield("Shieldy", 100);
// Gets enum instance constructor name
var constructorName = item.getName();
// Gets enum instance constructor index
var constructorIndex = item.getIndex();
// Gets enum instance constructor arguments
var constructorArguments = item.getParameters();

var otherItem = ItemType.Sword("Slashy", 100);
// Compares two enum instances recursively
if (item.equals(otherItem)) trace("Items are equal!");
// Matches enum instance against pattern
if (otherItem.match(ItemType.Shield(_, _))) trace("Other item is a shield!");
```

> Read more in the Haxe Manual:
> 
> * [Enum](https://haxe.org/manual/types-enum-instance.html)
> * [Pattern Matching](https://haxe.org/manual/lf-pattern-matching.html)
>
> Read more in the Haxe API documentation:
> 
> * [EnumTools](http://api.haxe.org/haxe/EnumTools.html)
> * [EnumValueTools](http://api.haxe.org/haxe/EnumValueTools.html)
>
> Author: [Domagoj Štrekelj](https://github.com/dstrekelj)
