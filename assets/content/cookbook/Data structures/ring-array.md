[tags]: / "collections"

# A fixed ring array

A fixed ring array is especially useful when you need a hard upper bound for how much data can be in the queue.

```haxe
// reference https://github.com/torvalds/linux/blob/master/include/linux/circ_buf.h
@:generic
class Ring<T> {

  var head: Int;
  var tail: Int;
  var cap: Int;
  var a: haxe.ds.Vector<T>;

  public function new(len) {
    if (len < 4) {
      len = 4;
    } else if (len & len - 1 > 0) {
      len--;
      len |= len >> 1;
      len |= len >> 2;
      len |= len >> 4;
      len |= len >> 8;
      len |= len >> 16;
      len++;       // power of 2
    }
    cap = len - 1; // only "len-1" available spaces
    a = new haxe.ds.Vector<T>(len);
    reset();
  }

  public function reset() {
    head = 0;
    tail = 0;
  }

  public function push(v: T) {
    if (space() == 0) tail = (tail + 1) & cap;
    a[head] = v;
    head = (head + 1) & cap;
  }

  public function shift(): Null<T> {
    var ret:Null<T> = null;
    if (count() > 0) {
      ret = a[tail];
      tail = (tail + 1) & cap;
    }
    return ret;
  }

  public function pop(): Null<T> {
    var ret:Null<T> = null;
    if (count() > 0) {
      head = (head - 1) & cap;
      ret = a[head];
    }
    return ret;
  }

  public function unshift(v: T) {
    if (space() == 0) head = (head - 1) & cap;
    tail = (tail - 1) & cap;
    a[tail] = v;
  }

  public function toString() {
    return '[head: $head, tail: $tail, capacity: $cap]';
  }

  public inline function count() return (head - tail) & cap;

  public inline function space() return (tail - head - 1) & cap;
}
```

## Usage

It's easy to implement `undo/redo` operations.

```haxe
@:generic class History<T> {
  var re: Ring<T>;
  var un: Ring<T>;
  public function new(len){
    re = new Ring<T>(len);
    un = new Ring<T>(len);
  }
  public function redo(): Null<T> {
    var r = re.pop();
    if (r != null) un.push(r);
    return r;
  }
  public function undo(): Null<T> {
    var u = un.pop();
    if (u != null) re.push(u);
    return u;
  }
  public function add(v: T) {
    un.push(v);
    re.reset();
  }
}

class Main {
  static function main() {
    var h = new History<Int>(4);
    h.add(1);
    h.add(2);
    h.add(3);
    h.add(4); // overrides the 1
    h.add(5);
    eq(h.undo() == 5);
    eq(h.undo() == 4);
    eq(h.undo() == 3);
    eq(h.undo() == null);
    eq(h.redo() == 3);
    eq(h.redo() == 4);
    eq(h.redo() == 5);
    eq(h.redo() == null);
    trace("done!");
  }
  static function eq(t: Bool, ?pos: haxe.PosInfos) {
    if (!t) throw '>>>>>> lineNumber: ${pos.lineNumber}';
  }
}
```

> Author: [R32](https://github.com/r32)
