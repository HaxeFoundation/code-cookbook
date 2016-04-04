# Lazy initialization 

This is a basic example of the [Lazy initialization](https://en.wikipedia.org/wiki/Lazy_initialization) design pattern in Haxe.

```haxe
class Fruit 
{
  private static var instances_:Map<String,Fruit> = new Map<String,Fruit>();
  public var name(default, null):String;
 
  public function new(name:String)
  {
    this.name = name;
  }
 
  public static function getFruitByName(name:String):Fruit
  {
    if (!instances_.exists(name)) {
      instances_.set(name, new Fruit(name));
    }
    return instances_.get(name);
  }
  
  public static function printCurrentTypes() {
    trace([for(key in instances_.keys()) key]);
  }
}
```

### Usage
  
```haxe
class Main 
{
  public static function main () 
  {
    Fruit.getFruitByTypeName("Banana");
    Fruit.printCurrentTypes(); // ["Banana"]
 
    Fruit.getFruitByTypeName("Apple");
    Fruit.printCurrentTypes(); // ["Banana","Apple"]
 
    Fruit.getFruitByTypeName("Banana");
    Fruit.printCurrentTypes(); // ["Banana"]
  }
}
```
