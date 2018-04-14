[tags]: / "collections"

# A fixed ring array

A fixed ring array are especially useful when you need a hard upper bound for how much data can be in the queue.

```haxe
@:generic class Ring<T> {
  public var cap(get, never): Int;
  inline function get_cap() return a.length;

  public var len(get, never): Int;
  inline function get_len() return i + left - start;

  var i: Int;
  var start: Int;
  var left: Int;
  var a: haxe.ds.Vector<T>;

  public function new(len) {
    a = new haxe.ds.Vector<T>(len);
    reset();
  }
  public function pop(): Null<T> {
    if (len <= 0) return null;
    if (i == 0) {
      i = cap;
      left = 0;
    }
    return a[--i];
  }
  public function shift(): Null<T> {
    if (len <= 0) return null;
    if (start == cap) {
      start = 0;
      left = 0;
    }
    return a[start++];
  }
  public function push(v: T) {
    if (i == cap) {
      if (left > 0 && start == i) start = 0;
      i = 0;
      left = cap;
    }
    if (len == cap) start++;
    a[i++] = v;
  }
  public function reset() {
    i = 0;
    start = 0;
    left = 0;
  }
  public function remove(v: T) {
    var cap = this.cap;
    var max = this.len;
    var j = 0, p = 0;
    while (j < max) {
      p = (j + start) % cap;
      if (v == a[p]) {
        if (p == start) {
          ++ start;
        } else {
          if (this.i == 0) {
            this.i = cap;
            this.left = 0;
          }
          -- max;
          while (j < max) {
            a[(j + start) % cap] = a[(j + start + 1) % cap];
            ++ j;
          }
          -- this.i;
        }
        break;
      }
      ++ j;
    }
  }
  public inline function toString() {
    return '[i: $i, start: $start, len: $len, left: $left]';
  }
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
    var h = new History<Int>(3);
    h.add(1);
    h.add(2);
    h.add(3);
    h.add(4); // overrided
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