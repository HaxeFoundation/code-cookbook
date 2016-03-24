# Reverse iterator

```haxe
class ReverseIterator {
  var end:Int;
  var i:Int;

  public inline function new(start:Int, end:Int) {
    this.i = start;
    this.end = end;
  }

  public inline function hasNext() return i >= end;
  public inline function next() return i--;
}
```

## Usage

Loop from 5 to 0.

```haxe 
for (i in new ReverseIterator(5, 0)) {
  trace(i);
}
// 5
// 4
// 3
// 2
// 1
// 0
```

> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>