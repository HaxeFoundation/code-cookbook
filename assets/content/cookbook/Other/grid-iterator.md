[tags]: / "iterator"

# Grid iterator

Often, in games or UI, you might want to create a grid. 

A [custom iterators](http://haxe.org/manual/lf-iterators.html) can provide such functionality.

```haxe
class GridIterator {
  var gridWidth:Int = 0;
  var gridHeight:Int = 0;
  var i:Int = 0;

  public inline function new(gridWidth:Int, gridHeight:Int) {
    this.gridWidth = gridWidth;
    this.gridHeight = gridHeight;
  }

  public inline function hasNext() {
    return i < gridWidth * gridHeight;
  }

  public inline function next() {
    return new GridIteratorObject(i++, gridWidth);
  }
}

class GridIteratorObject {
  public var index(default, null):Int;
  public var x(default, null):Int;
  public var y(default, null):Int;

  public inline function new(index:Int, gridWidth:Int) {
    this.index = index;
    this.x = index % gridWidth;
    this.y = Std.int(index / gridWidth);
  }
}
```

## Usage

The following example uses the GridIterator and displays a grid of 6x5 using dark colored divs.
Because of the used `js` package/features, it only compiles in the JavaScript target.

<iframe src="http://try.haxe.org/embed/F80dA" width="100%" height="350" frameborder="no" allowfullscreen style="border:1px solid #ccc;border-radius:10px;box-shadow:0 0 5px #ccc">
	<a href="http://try.haxe.org/#F80dA">Try Haxe !</a>
</iframe>

> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>