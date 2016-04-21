# Singleton 

This is a basic example of the [Singleton](https://en.wikipedia.org/wiki/Singleton_pattern) design pattern in Haxe.

```haxe
class MySingleton {
  public static var instance(get, null):T;
  static function get_instance() {
    if (instance == null) {
      instance = new MySingleton();
    }
    return instance;
  }

  private function new () {}  // private constructor
}
```

### Usage
  
```haxe
class Main {
  public static function main () {
    // this will be the only way to access the instance
    MySingleton.instance;

    // This will throw error "Cannot access private constructor"
    // new MySingleton(); 
  }
}
```
