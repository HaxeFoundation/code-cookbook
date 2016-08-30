[tags]: / "class"

# Inheritance

Classes inherit from other classes using the `extends` keyword:

```haxe
class Point2d {
  public var x:Int;
  public var y:Int;

  public function new(x, y) {
    this.x = x;
    this.y = y;
  }
}

class Point3d extends Point2d {
  public var z:Int;

  public function new(x, y, z) {
    super(x, y);
    this.z = z;
  }
}
```

## Interfaces can also extend

```haxe
interface Debuggable extends Printable extends Serializable
```