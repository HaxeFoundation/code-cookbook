[tags]: / "math"

# Using lists

In Haxe, the `List` type represents a linked-list of elements.

### Creation

Lists can only be created through the use of a constructor. The constructor requires a type parameter to be passed, which specifies the type of the elements in the list.

```haxe
var listOfInts = new List<Int>();
var listOfStrings = new List<String();
var listOfMyType = new List<MyType>();
var listOfListsOfMyType = new List<List<MyType>>();
```

### Adding elements

List elements can be appended to the end (tail) of the list, or prepended to the beginning (head) of the list. Elements cannot be inserted into a specific place in the list.

```haxe
listOfInts.add(1);      // Adds 1 to the tail of the list
listOfInts.push(2);     // Adds 2 to the head of the list
```

### Removing elements

List elements can be removed by passing a reference or value of the list element to be removed. In that case, the first occurence of the passed element wiill be removed to the list. List elements can also be instantly removed from the top of the list.

```haxe
listOfInts.remove(1);   // Removes first occurence of 1 in list
listOfInts.pop();       // Removes and returns the head element of the list
```

### Retrieving elements

Only the first (head) and last (tail) element of the list can be directly retrieved.

```haxe
listOfInts.first();     // Returns the head element of the list
listOfInts.last();      // Returns the tail element of the list
```

### Iteration

The list defines an iterator, and its elements can therefore be iterateed over.

```haxe
for (item in listOfInts) {
    // do something
}
```

### Operations

List elements can be mapped to a new list of elements via a mapping function. The mapping is bijective, and every element from the inital list will have its mapping in the new list.

List elements can also be filtered into a new list via a filtering function. Every list element for which the filtering function returns `true` is added to a new list.

```haxe
// Returns a new list of elements processed by provided mapping function
var listOfIntsAsStrings = listOfInts.map(function (e) return Std.string(e));
// Returns a new list of elements for which the filter function returns true
var listOfEvenInts = listOfInts.filter(function (e) return e % 2 == 0);
```

### Displaying list contents

Lists can be prepared for printing by joining the elements together with a separator character, or by using the string representation of the list structure.

```haxe
// Returns a string of list elements concatenated by separator string
var withSeparator : String = listOfInts.join(" / ");
// Returns a string representation of the list structure
var asStructure : String = listOfInts.toString();
```

> [List API documentation](http://api.haxe.org/List.html)
> 
> [List manual entry](http://haxe.org/manual/std-List.html)
>
> Author: [Domagoj Štrekelj](https://github.com/dstrekelj)
