[tags]: / "array"

# Sorting arrays

### Sort an array of values

You can easily sort an array using the Array's `sort()` function.
```haxe
var myArray = [1,5,3,7,6,2,4];
myArray.sort(function(a, b) return a - b);
trace(myArray); // 1,2,3,4,5,6,7
```

### Sort using Reflect.compare

Reflect.compare works like this: 
> If a is less than b, the result is negative. If b is less than a, the result is positive. If a and b are equal, the result is 0.

It handles multiple types, so take in account `Reflect.compare` carries a bit of overhead.

The previous example can be shortened if you are using `Reflect.compare`. 
```haxe
var myArray = [1,5,3,7,6,2,4];
myArray.sort(Reflect.compare);
trace(myArray); // 1,2,3,4,5,6,7
```

These sortings aren't [stable](https://en.wikipedia.org/wiki/Sorting_algorithm#Stability) on all targets. If you need to retain the order of equal elements you should use `haxe.ds.ArraySort`

###  Using haxe.ds.ArraySort

```haxe
var myArray = [1,5,3,7,6,2,4];

haxe.ds.ArraySort.sort(myArray, function(a, b):Int {
  return a - b;
});
```
> Learn more about `haxe.ds.ArraySort`: <http://api.haxe.org/haxe/ds/ArraySort.html>


## Usage

### Simple array with ints
[tryhaxe](http://try.haxe.org/embed/D7880)
  
### Array with objects
[tryhaxe](http://try.haxe.org/embed/76f24)

Notice how the second array, when using `haxe.ds.ArraySort`, keeps the order of the elements with equal `i`. The sorting is stable.


