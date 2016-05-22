# Singleton 

This is a basic example of the [Singleton](https://en.wikipedia.org/wiki/Singleton_pattern) design pattern in Haxe.

```haxe
class MySingleton {
  // read-only property
  public static var instance(default, null):MySingleton = new MySingleton();
  
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
