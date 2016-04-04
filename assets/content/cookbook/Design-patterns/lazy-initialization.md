# Lazy initialization 

This is a basic example of the [Lazy initialization](https://en.wikipedia.org/wiki/Lazy_initialization) design pattern in Haxe.

```haxe
class Fruit {
  private static var _instances = new Map<String, Fruit>();

  public var name(default, null):String;

  public function new(name:String) {
    this.name = name;
  }

  public static function getFruitByName(name:String):Fruit {
    if (!_instances.exists(name)) {
      _instances.set(name, new Fruit(name));
    }
    return _instances.get(name);
  }

  public static function printAllTypes() {
    trace([for(key in _instances.keys()) key]);
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
