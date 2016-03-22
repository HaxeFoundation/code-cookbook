# Object pool 

This is a basic example of the [Object pool](https://en.wikipedia.org/wiki/Object_pool_pattern) design pattern in Haxe.

```haxe
class Pool<A>
{
  private var _allocator:Void -> A;
  private var _pool:Array<A>;
  private var _capacity:Int;
  
  public function new (allocator:Void -> A, capacity:Int = 100)
  {
    _allocator = allocator;
    _pool = [];
    _capacity = capacity;
  }

  public function get():A
  {
    if (_pool.length > 0) {
      return _pool.pop();
    }
    return allocator();
  }

  public function put(item :A)
  {
    if (item != null && _pool.length < _capacity) {
      _pool.push(item);
    }
  }
}
```

### Usage
  
```haxe
class Main 
{
  public static function main () 
  {
    var pool = new Pool<Item>(function() return new Item());
    
    // grab item from pool
    var item = pool.get();
    
    // give item back to pool
    pool.put(item);
  }
}

class Item {
  public function new() { }
}
```