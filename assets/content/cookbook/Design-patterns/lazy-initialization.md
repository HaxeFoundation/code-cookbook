# Lazy initialization 

This is a basic example of the [Lazy initialization](https://en.wikipedia.org/wiki/Lazy_initialization) design pattern in Haxe.

```haxe
class Fruit {
  private static var instances_ = new Map<String, Fruit>();

  public var name(default, null):String;

  public function new(name:String) {
    this.name = name;
  }

  public static function getFruitByName(name:String):Fruit {
    if (!instances_.exists(name)) {
      instances_.set(name, new Fruit(name));
    }
    return instances_.get(name);
  }

  public static function printAllTypes() {
    trace([for(key in instances_.keys()) key]);
  }
}
```

### Usage
  
```haxe
class Test {
  public static function main () {
    var banana = Fruit.getFruitByName("Banana");
    var apple = Fruit.getFruitByName("Apple");
    var banana2 = Fruit.getFruitByName("Banana");
    
    trace(banana == banana2); // true. same banana
    
    Fruit.printAllTypes(); // ["Banana","Apple"]
  }
}
```
