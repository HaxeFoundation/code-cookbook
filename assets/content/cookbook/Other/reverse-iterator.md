[tags]: / "iterator"

# Reverse iterator

Haxe has a special [range operator](http://haxe.org/manual/expression-for.html) `for(i in 0...5)` to iterate forward. 
Because it requires `min...max`, you cannot do `for(i in 5...0)`, thus you cannot iterate backwards using this syntax.

You could use a [while loop](http://haxe.org/manual/expression-while.html) for this:
  
```haxe
var total = 5;
var i = total;
while(i >= 0) {
  trace(i);
  i --;
}
// 5
// 4
// 3
// 2
// 1
// 0
```

This is not always optimal since you need variables outside the loop. 

You can also create [custom iterators](http://haxe.org/manual/lf-iterators.html) which provide such functionality.

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

[tryhaxe](http://try.haxe.org/embed/ae6ef)

> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>