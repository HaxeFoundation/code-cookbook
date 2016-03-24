# Stepped iterator

```haxe
class StepIterator {
  var end:Int;
  var step:Int;
  var index:Int;

  public inline function new(start:Int, end:Int, step:Int) {
    this.index = start;
    this.end = end;
    this.step = step;
  }

  public inline function hasNext() return index < end;
  public inline function next() return (index += step) - step;
}
```

## Usage

Loop in steps of two from 0 to 10.

```haxe 
for (i in new StepIterator(0, 10, 2)) {
  trace(i);
}
// 0
// 2
// 4
// 6
// 8
```

> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>