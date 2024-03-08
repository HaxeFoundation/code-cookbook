[tags]: / "iterator"

# Enumerate iterator

At times, iterating over an array requires access to both the item and its index. It is such a common usecase that python has a built in function [enumerate](https://docs.python.org/3/library/functions.html#enumerate) that does exactly this.

This custom iterator provides the same functionality, taking advantage of the "key => value" iteration that is used when iterating maps.

```haxe
class EnumerateIterator<T> {
  var array:Array<T>;
  var idx:Int;

  public function new(array:Array<T>) {
    this.array = array;
    this.idx = 0;
  }

  public function next():{key:Int, value:T} {
    return {key: idx, value: array[idx++]};
  }

  public function hasNext():Bool {
    return idx < array.length;
  }

  public static function enumerate<T>(array:Array<T>):EnumerateIterator<T> {
    return new EnumerateIterator<T>(array);
  }
}
```

## Usage 

The most convenient way by importing with 'using'

```haxe
using EnumerateIterator;

var arr = ["haxe", "is", "for", "winners"]
for (idx => item in arr.enumerate()) {
  trace(idx, item);
}
```

Alternatively

```haxe
import EnumerateIterator;

var arr = ["haxe", "is", "for", "winners"]
for (idx => item in EnumerateIterator.enumerate(arr)) {
  trace(idx, item);
}
```

> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>
