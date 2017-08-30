# Using strings

Defining string literals take be done by wrapping text inside double or single quotes:

```haxe
"string text";
'string text';
```

Assigning strings to variables:

```haxe
var a:String = "a"; // with type declaration
var b = "b"; // without type declaration
```
Combine two strings:

```haxe
var greeting = "hello";
var message = greeting + " world"; 
trace(message); // output: hello world
```

### String interpolation / Template literals

In Haxe string literals can also be [template literals](https://haxe.org/manual/lf-string-interpolation.html) using so-called string interpolation. This only works when you use _single quotes_.

```haxe
var name = "Mark";
var age = 33;
var message = 'Hello, I am $name and my age is $age';
trace(message); // output: Hello, I am Mark and my age is 33
```
Note that this is basically the same as writing: 
`var message = "Hello, I am " + name + " and my age is " + age`

In simple cases you can use `$myvariable`, for more complex expressions you can use `${myvariable}`.

```haxe
var age = 33;
var year = 2017;
var message = 'I am born in ${year - age}';
trace(message); // output: I am born in 1984
```

### String operations

It is possible to use multiple operators on a string: 

```haxe
// add two strings
trace("apple" + "pear"); // applepear

// compare if both are the same
trace("apple" == "pear"); // false
trace("apple" == "apple"); // true

// compare if both are different
trace("strawberry" != "blueberry"); // true
trace("patato" != "patato"); // false
```

It is also possible to compare strings with other operators:

```haxe
trace("ABCB" > "ABBBB"); // true
trace("ABCB" < "AAAA"); // false
```
So, "ABCB" is greater than "ABBBB". This works like this because strings are compared [lexicographically](https://en.wikipedia.org/wiki/Lexicographical_order). Lexical order (according Wikipedia) is a generalization of the way the alphabetical order of words is based on the alphabetical order of their component letters.

This can be useful when you for example want so sort a list of strings:
	
```haxe
// Creating an array with strings
var fruits:Array<String> = ["apple", "pear", "banana"];
fruits.sort(function(a, b) return a > b ? 1 : -1);
trace(fruits); // output: apple,banana,pear
```
Note that this can also be confusing when there are numbers in the text: e.g. `"11.5" > "3"` will result to `false`. This is because "1" comes earlier in the alphabet than "3".
If you expect it to work those strings as actual numbers, you need to convert them to numbers first:
```haxe
var a = "11.5";
var b = "3";
trace(a > b); // false
trace(Std.parseFloat(a) > Std.parseInt(b)); // true because compared as actual numbers
```

### Multiline strings

Long literal strings in Haxe can be written easily. String are multi-line:

```haxe
var fruits = "
- apple
- pear
- banana";
```

### String manipulation

String has various methods for manipulating text. These method does not change the original string, but return a new one instead. See the [String API documentation](http://api.haxe.org/String.html) for all string methods.
```haxe
trace("Haxe is great!".toUpperCase()); // HAXE IS GREAT!
trace("Haxe is great!".toLowerCase()); // haxe is great!
```

Reverse a string:

```haxe
function reverse(a:String):String {
  var arr = a.split('');
  arr.reverse();
  return arr.join('');
}

trace(reverse("Haxe is great!")); // !taerg si exaH
```

For more string methods, [`StringTools`](http://api.haxe.org/StringTools.html) in the Haxe Standard Library provides a lot more methods for Strings. Here are a few examples:

```haxe
trace(StringTools.replace("Haxe is great!", "great", "fun")); // Haxe is fun!
trace(StringTools.startsWith("Haxe is great!", "Haxe")); // true
trace(StringTools.endsWith("Haxe is great!", "Haxe")); // false
trace("#" + StringTools.hex(255, 6)); // #0000FF
```
StringTools is ideally used with `using StringTools` and then acts as [an extension](https://haxe.org/manual/lf-static-extension.html) to the String class, this would allow to do:
```haxe
trace("Haxe is great!".replace("great", "fun")); // Haxe is fun!
trace("Haxe is great!".startsWith("Haxe")); // true
trace("Haxe is great!".endsWith("Haxe")); // false
```

### Single string character code

Use `.code` on a constant single character to compile its ASCII character code:
```haxe
trace("\n".code); // output: 10
trace("@".code); // // output: 64
```
If you need to do this with a runtime string character, you can use `StringTools.fastCodeAt`.

> **API documentation**
> 
> * [String API documentation](http://api.haxe.org/String.html)
> * [StringTools API documentation](http://api.haxe.org/StringTools.html)
>
> **Manual**
> 
> * [String in Manual](https://haxe.org/manual/std-String.html)
> * [String interpolation in Manual](https://haxe.org/manual/lf-string-interpolation.html)
