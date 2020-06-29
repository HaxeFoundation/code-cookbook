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


# Reverse array iterator

Here is an example of a reverse iterator for arrays, which gives you value.

```haxe
class ReverseArrayIterator<T> {
	final arr:Array<T>;
	var i:Int;

	public inline function new(arr:Array<T>) {
		this.arr = arr;
		this.i = this.arr.length - 1; 
	}

	public inline function hasNext() return i > -1;
	public inline function next() {
		return arr[i--];
	}

	public static inline function reversedValues<T>(arr:Array<T>) {
		return new ReverseArrayIterator(arr);
	}
}
```

## Usage

If you add `using ReverseArrayIterator` to your class (or to global imports.hx), you can use `for (item in array.reversedValues())` in your code.  
But if you don't want to do that you can always do `for (item in new ReverseArrayIterator(array))`.

```haxe
using ReverseArrayIterator;

class Test {
  public function new() {
    var fruits = ["apple", "banana", "pear"];
    for (fruit in fruits.reversedValues()) {
      trace(fruit);
    }
  }
}
```

# Reverse key-value array iterator

Key value iterators are great because it gives you both the key and the value while iterating. 
Here is an example of a reverse iterator for arrays, which gives you both index and value.

```haxe
class ReverseArrayKeyValueIterator<T> {
	final arr:Array<T>;
	var i:Int;

	public inline function new(arr:Array<T>) {
		this.arr = arr;
		this.i = this.arr.length - 1; 
	}

	public inline function hasNext() return i > -1;
	public inline function next() {
		return {value: arr[i], key: i--};
	}

	public static inline function reversedKeyValues<T>(arr:Array<T>) {
		return new ReverseArrayKeyValueIterator(arr);
	}
}
```

## Usage

If you add `using ReverseArrayKeyValueIterator` to your class (or to global imports.hx), you can use `for (idx => item in array.reversedKeyValues())` in your code.  
But if you don't want to do that you can always do `for (idx => fruit in new ReverseArrayKeyValueIterator(fruits))`.

```haxe
using ReverseArrayKeyValueIterator;

class Test {
  public function new() {
    var fruits = ["apple", "banana", "pear"];
    for (idx => fruit in fruits.reversedKeyValues()) {
      trace(idx, fruit);
    }
  }
}
```

> Learn more about iterators here: <http://haxe.org/manual/lf-iterators.html>
