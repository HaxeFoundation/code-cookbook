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

[tryhaxe](http://try.haxe.org/embed/F80dA)

---

# Grid Key value iterator

In Haxe 4, as alternative, you can also use a [key value iterator](https://haxe.org/manual/expression-for.html#key-value-iteration).

```haxe
class GridIterator {
  var gridWidth:Int = 0;
  var gridHeight:Int = 0;
  var i:Int = -1;

  public inline function new(gridWidth:Int, gridHeight:Int) {
    this.gridWidth = gridWidth;
    this.gridHeight = gridHeight;
  }

  public inline function hasNext() {
    return i < gridWidth * gridHeight;
  }

  public inline function next() {
    i++;
    return { key: i, value: { x: i % gridWidth, y: Std.int(i / gridWidth) } }
  }
}
```

## Usage 

```haxe
for (idx => pos in new GridIterator(6, 5)) {
  trace(idx, pos.x, pos.y);
}
```


> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>
