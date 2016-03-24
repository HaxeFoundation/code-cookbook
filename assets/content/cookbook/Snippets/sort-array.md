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
