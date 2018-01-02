# Observer

This is a basic example of the [Observer](https://en.wikipedia.org/wiki/Observer_pattern) design pattern in Haxe. The pattern makes use of an `Observer` interface and an `Observable` base class to notify objects when another object's property is changed so that they can react accordingly.

```haxe
interface Observer {
  public function notified(sender:Observable, ?data:Any) : Void;
}

class Observable {
  private var observers:Array<Observer> = [];
  public function new() { }
  
  private function notify<T>(?data:T) {
    for(obs in observers)
      obs.notified(this, data);
  }
  
  public function addObserver(observer:Observer) {
    observers.push(observer);
  }
}
```

### Usage
  
[Try Haxe sample](https://try.haxe.org/embed/786A5)

### Notes

- Extra care has to be put into making sure that an observable cannot register the same observer twice.
- The fact that `Observable` is a class can make it hard to use because Haxe does not allow for multiple inheritance. Instead, we used a static extension for convenient usage.
