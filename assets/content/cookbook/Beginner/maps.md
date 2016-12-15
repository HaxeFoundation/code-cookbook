[tags]: / "collections, data-structures"

# Using maps

In Haxe, `Map` (also known as dictionary) allows key to value mapping for arbitrary value types and many key types. 

To use a map you can use the convenient `Map` abstract class in the [`toplevel` package](http://api.haxe.org/), which automatically instantiates a specialized map based on the type parameters:

| Map | Key type | Specialized map used |
| --- | --- | --- |
| `Map<String, V>` | `String` | `haxe.ds.StringMap` |
| `Map<Int, V>` | `Int` | `haxe.ds.IntMap` |
| `Map<EnumValue, V>` | `EnumValue` | `haxe.ds.EnumValueMap` |
| `Map<MyType, V>` | class or structure | `haxe.ds.ObjectMap` |
| `Map<String, V>` | other type | compile-time error |



The type of the value `V` can be any other type. All the specialized maps can ofcourse be used directly and have the same functionalities, but the underlying implementations are different for optimal performance. 
`Map` however provides some features which the concrete types don't have which is explained later.

The specialized maps can be found in the [`haxe.ds` package](http://api.haxe.org/haxe/ds/).

### Create a Map / Setting values

Since `Map` is the easiest to work with, we'll use it in this article and start with creating a map with strings as keys and integers as values.

If you are using `Map` you can use array access to set values `map[key] = value`, otherwise you have to use `map.set(key, value)`. Another reason to use `Map` as much as possible.

```haxe
var ageByUser = new Map<String, Int>(); 
ageByUser["John"] = 26;
ageByUser["Peter"] = 17;
ageByUser["Mark"] = 32;
```

This is the same as writing:
```haxe
var ageByUser = new StringMap<Int>();
ageByUser.set("John", 26);
ageByUser.set("Peter", 17);
ageByUser.set("Mark", 32);
```

> The naming convention of the map variable is _"meaning of value by meaning of key"_.

A different way to create a map with values directly is using the [comprehension syntax](http://haxe.org/manual/lf-array-comprehension.html) (`key1 => value1, key2 => value2`):

```haxe
var ageByUser = [
  "John" => 26,
  "Peter" => 17,
  "Mark" => 32,
];
```

To give a quick visual of what we've just created above, this would be the data of our `ageByUser` map:

| Key _user_ | Value _age_ |
| --- | --- |
| John | 26 |
| Peter | 17 |
| Mark | 32 |

### Retrieving values

Now we know how to create a map and set values, let's get a value and trace it:

As explained earlier, if you are using `Map` you can use array access to get values `map[key]`, otherwise you have to use `map.get(key)`. 

```haxe
var ageOfMark = ageByUser["Mark"];
trace(ageOfMark); 
// output: 32

// same as:
var ageOfMark = ageByUser.get("Mark");
trace(ageOfMark); 
// output: 32
```

If the user "Mark" wouldn't exist in the map, the variable `ageOfMark` would be `null`. To be absolute sure if a certain _key_ exists, you can check it using the `map.exists` function.

```haxe
// Search for the user "Simon", which isn't defined in our map and trace its age.
var user = "Simon";
if (ageByUser.exists(user)) {
  var age = ageByUser[user];
  trace('$user is $age years old');
} else {
  trace('$user is not found');
}
```

### Removing values

You can remove values using the `map.remove` function. 

```haxe
var user = "John";
ageByUser.remove(user);

// double check
trace(ageByUser.exists(user)); // false
trace(ageByUser.get(user)); // null
```

### Iteration

To iterate over all values of the map, use `for (value in map)`.  
In our example the values are defining the user's age, let's trace all ages.

```haxe
for (age in ageByUser) {
  trace(age);
}
```

To iterate over the keys of the map, use `for (key in map.keys())`.  
In our example the keys are user names, let's trace all names.

```haxe
for (user in ageByUser.keys()) {
  trace(user);
}
```

Of course this can be combined, let's trace the user and its age:

```haxe
for (user in ageByUser.keys()) {
  var age = ageByUser[user];
  trace('$user is $age years old');
}
```

The order of both values and keys in any type of map is undefined, therefore you shouldn't rely it. If order is important (when the map needs to be sorted for example), convert it to an Array. 
This can be easily done with [`Lamba.array(map)`](http://api.haxe.org/Lambda.html#array) to get the values as Array or `Lambda.array(map.keys())` if you want the keys as Array.

> **More information:**
> 
> * [Map API documentation](http://api.haxe.org/Map.html)
> * [Haxe data structures API documentation](http://api.haxe.org/haxe/ds/)
> * [Map manual entry](https://haxe.org/manual/std-Map.html)
>
> Author: [Mark Knol](https://github.com/markknol)
