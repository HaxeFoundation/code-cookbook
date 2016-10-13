[tags]: / "array"

# Sorting arrays

### Sort an array of values

```haxe
myArray.sort(function(a, b):Int {
  if (a < b) return -1;
  else if (a > b) return 1;
  return 0;
});
```
This method isn't [stable](https://en.wikipedia.org/wiki/Sorting_algorithm#Stability) on all targets. If you need to retain the order of equal elements you should use `haxe.ds.ArraySort`

###  Using haxe.ds.ArraySort

```haxe
haxe.ds.ArraySort.sort(myArray, function(a, b):Int {
  if (a < b) return -1;
  else if (a > b) return 1;
  return 0;
});
```
> Learn more about `haxe.ds.ArraySort`: <http://api.haxe.org/haxe/ds/ArraySort.html>


## Usage

### Simple array with ints
[tryhaxe](http://try.haxe.org/embed/D7880)
  
### Array with objects
[tryhaxe](http://try.haxe.org/embed/76f24)

Notice how the second array, when using `haxe.ds.ArraySort`, keeps the order of the elements with equal `i`. The sorting is stable.


