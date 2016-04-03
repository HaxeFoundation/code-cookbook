[tags]: / "iterator"

# Stepped iterator

Haxe has a special [range operator](http://haxe.org/manual/expression-for.html) `for(i in 0...5)` to iterate forward. 
This does not allow to modify `i` in place, thus you cannot make it iterate in steps.

You could use a [while loop](http://haxe.org/manual/expression-while.html) for this:
  
```haxe
var total = 10;
var step = 2;
var i = 0;
while(i < total) {
  trace(i);
  i += step;
}
// 0
// 2
// 4
// 6
// 8
```

This is not always optimal since you need variables outside the loop. 

You can also create [custom iterators](http://haxe.org/manual/lf-iterators.html) which provide such functionality.

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

[tryhaxe](http://try.haxe.org/embed/9F186)

> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>