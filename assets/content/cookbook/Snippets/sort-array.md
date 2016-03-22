# Sorting arrays

### Sort an array of values:


```haxe
myArray.sort(function<T>(a:T, b:T):Int {
    if (a < b) return -1;
    else if (a > b) return 1;
    return 0;
});

```

### Alternative using reflection
  
```haxe
myArray.sort(function<T>(a:T, b:T):Int {
    return Reflect.compare(a,b);
});
```

### Using constrained type parameters

```
class Test {
    static function main() {
        var myArray = [1,2,3,4,2,2,1];
        myArray.sort(sortFunction);
    }
    
    static function sortFunction<T:Float>(a:T, b:T):Int {
        if (a < b) return -1;
        else if (a > b) return 1;
        return 0;
    }
}
```