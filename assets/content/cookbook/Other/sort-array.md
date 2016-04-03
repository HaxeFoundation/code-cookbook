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

### Alternative using reflection
  
```haxe
myArray.sort(function(a, b):Int {
  return Reflect.compare(a,b);
});
```
> Learn more about `Reflect.compare()`: <http://api.haxe.org/Reflect.html#compare>

### Using haxe.ds.ArraySort

```haxe
haxe.ds.ArraySort.sort(myArray, function(a, b):Int {
  if (a < b) return -1;
  else if (a > b) return 1;
  return 0;
});
```
> Learn more about `haxe.ds.ArraySort`: <http://api.haxe.org/haxe/ds/ArraySort.html>

## Usage

[tryhaxe](http://try.haxe.org/embed/aE8c8)

Notice how the second array, when using `haxe.ds.ArraySort`, keeps the order of the elements with equal `i`.


