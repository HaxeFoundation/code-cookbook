[tags]: / "array, collections, data-structures"

# Using arrays

In Haxe, the `Array` type represents a collection of elements ordered by their index (order number) in the collection.

## Creation

Arrays can be created by using the array syntax (`[]`), or by using a constructor. The constructor requires a type parameter to be passed, which specifies the type of the elements in the array. When the array syntax is used, the casting determines the type of array constructed.

```haxe
// Creating an array using array syntax and explicit type definition Array<String>
var strings:Array<String> = ["Apple", "Pear", "Banana"];
trace(strings);

// Creating an array with float values
// Here, the type definition Array<Float> is left out - it is infered by the compiler
var floats = [10.2, 40.5, 60.3];
trace(floats);
```

### Array comprehension

As an alternative, [array comprehension](https://haxe.org/manual/lf-array-comprehension.html) can be used. This makes it possible to use some programming logic in `for` or `while` expressions:

```haxe
var ints = [for(i in 0...5) i];
trace(ints); // [0,1,2,3,4]

var evens = [for(i in 0...5) i*2];
trace(evens); // [0,2,4,6,8]

var chars = [for(c in 65...70) String.fromCharCode(c)];
trace(chars); // ['A','B','C','D','E']         

var x = 1;
var bits = [while(x <= 64) x = x * 2];
trace(bits); // [2,4,8,16,32,64,128]
```

# Adding elements

An element can be inserted into an array at a desired position, prepended to the start of the array, or appended to the end of the array. Multiple elements can be appended to an array through concatenation.

```haxe
var strings:Array<String> = [];

// Adds "Hello" at index 0, offsetting elements to the right by one position
strings.insert(0, "Hello");

// Prepends "Haxe" to the start of the array
strings.unshift("Haxe");

// Appends "World" to the end of the array 
strings.push("World");

// Appends "foo", "bar" elements to the end of a copy of the array
strings = strings.concat(["foo", "bar"]);
```

# Removing elements

Elements can be removed from an array by removing a specific element of the array, a range of elements in the array, the first element of the array, or the last element of the array.

```haxe
var strings:Array<String> = ["first", "foo", "middle", "foo", "last"];

// Removes first occurence of "middle" in the array
strings.remove("middle");

// Removes and returns three elements beginning with (and including) index 0
var sub = strings.splice(0, 3);

// Removes and returns first element of the array
var first = strings.shift();

// Removes and returns last element of the array
var last = strings.pop();
```

Modifying the array while iterating is so-called "undefined behavior", so it's not safe to do.

That means these are your options:

* [Reverse iterate](https://code.haxe.org/category/data-structures/reverse-iterator.html) and remove.
* If you iterate by increment the index you can get away with not increment the index it in case of removal (using `while` loop).
* Or sometimes you might prefer to just build a new array instead.

# Retrieving elements

Array elements can be accessed through array notation, using the index of the element in the array.

```haxe
var strings:Array<String> = ["first", "foo", "middle", "foo", "last"];

// Retrieves first array element
var first = strings[0];

// Retrieves last array element
var last = strings[strings.length - 1];

// Retrieves first occurrence of "foo" string
var first = strings[strings.indexOf("foo")];

// Retrieves last occurrence of "foo" string
var last = strings[strings.lastIndexOf("foo")];
```

# Iteration

The array defines an iterator, and its elements can therefore be iterated over in a for loop:

```haxe
var items = ["a", "b", "c"];
for (item in items) {
    trace(item);
}
// a
// b
// c
```

Using the `index => item` notation in the for loop is the simplest way to get the current item as well as its index:

```haxe
var var items = ["a", "b", "c"];
for (index => item in items) {
    trace('$index : $item');
}
// 0 : a
// 1 : b
// 2 : c
```

You can also iterate using the array index:

```haxe
var items = ["a", "b", "c"];
for (index in 0...items.length) {
    trace('$index : ${items[index]}');
}
```

# Operations

### Copy

Array elements can be copied into a new array.

```haxe
var strings:Array<String> = ["first", "second", "last"];
var stringsCopy = strings.copy();

stringsCopy.push("best"); // add extra value to the copied list

trace(strings); // ["first", "second", "last"];
trace(stringsCopy); // ["first", "second", "last", "best"];
```

### Filter

Array elements can be filtered into a new array with a filtering function. Every array element for which the filtering function returns `true` is added to a new array.

```haxe
var fruits:Array<String> = ["apple", "pear", "banana"];
var bananas = list.filter(item -> item == "banana");
trace(bananas); // ["banana"]
```
You can also filter an array using array comprehension:

```haxe
var fruits:Array<String> = ["apple", "pear", "banana"];
var bananas = [for (v in list ) if (v == "banana") v];
trace(bananas); // ["banana"]
```

### Map

Array elements can be mapped into a new array with a mapping function. The mapping is bijective and every element from the initial array will have its mapping in the new array. The order of elements is preserved.

```haxe
var items:Array<String> = ["first", "second", "last"];
var importantItems = list.map(item -> item.toUpperCase());
trace(importantItems); // ["FIRST","SECOND","LAST"]
```

You can also map an array using array comprehension:

```haxe
var items:Array<String> = ["first", "second", "last"];
var importantItems = [for(v in list) v.toUpperCase()];
trace(importantItems); // ["FIRST","SECOND","LAST"]
```

Mapping can be useful to translate an array to a different type of array.

```haxe
var strings:Array<String> = ["1.1", "1.2", "1.3"];
var floats:Array<Float> = strings.map(Std.parseFloat);
trace(floats); // [1.1, 1.2, 1.3]
```

### Reverse

The order of elements in an array can be reversed.

```haxe
var items:Array<String> = ["first", "second", "last"];
items.reverse();
trace(items); // ["last","second","first"]
```

### Slice

A specific range of array elements from a starting index up to (excluding) an end index can be copied to a new array.

```haxe
var items:Array<String> = ["first", "second", "last"];
var sub = list.slice(1, 2);
trace(sub); // ["second"]
``` 

### Sort

Array elements can be sorted according to a comparison function. The comparison function compares two elements (the predecessor and the successor), and must return an `Int`. A return value of 0 indicates the elements are equivalent, a positive return value gives way to the successor, and a negative return value gives way to the predecessor.

```haxe
var ints:Array<Int> = [1,5,2,4,3];
ints.sort(function (a, b) return a - b);
trace(ints); // [1,2,3,4,5]
```
```haxe
var strings:Array<String> = ["c", "a", "b"];
strings.sort(function (a, b) return if (a < b) -1 else 1);
trace(strings); // ["a","b","c"]
```

# Displaying contents

Arrays can be prepared for printing by joining the elements together with a separator character, or by using the string representation of the array structure.

```haxe
var items:Array<String> = ["first", "second", "last"];
// Returns a string of array elements concatenated by separator string
var joinedItems:String = list.join(" / ");
trace(joinedItems); // "first / second / last"
    
// Returns a string representation of the array structure
var itemsAsString:String = items.toString();
trace(itemsAsString); // "first,second,last"
```

# Multidimensional arrays

Multidimensional array is equivalent of spreadsheet with rows and columns and is represented by creating arrays within arrays.
In other words we create an array that contains elements which are arrays (nested arrays) 
The most basic type of multidimensional array is two-dimensional array. 

###  Create two dimensional array 

```haxe
var array2d:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0]];
```
Or using array comprehension syntax:
```haxe
var array2d:Array<Array<Int>> = [for (x in 0...2) [for (y in 0...3) 0]];
```
 
###  Create three dimensional array

```haxe
var array3d:Array<Array<Array<Int>>> = [
  [ [0, 0, 0], [0, 0, 0], [0, 0, 0], ],
  [ [0, 0, 0], [0, 0, 0], [0, 0, 0], ],
];
```
Or using array comprehension syntax:
```haxe
var array3d : Array<Array<Array<Int>>> = [for (x in 0...2) [for (y in 0...3) [for (z in 0...3) 0]]];
```
 
### Retrieving array elements 
 
We can receive  the whole row as array or only specific value from the array.
 
```haxe
// Retrieves the array 
var arrayOfInts:Array<Int> = array2d[0];
var arrayOfArrayOfInts:Array<Array<Int>> = array3d[0];
// Retrieves only first element 
var first2d = array2d[0][0];
var first3d = array3d[0][0][0];
```
 
> [Array API documentation](http://api.haxe.org/Array.html)
> 
> [Array manual entry](http://haxe.org/manual/std-Array.html)
>
> Author: [Domagoj Štrekelj](https://github.com/dstrekelj)
