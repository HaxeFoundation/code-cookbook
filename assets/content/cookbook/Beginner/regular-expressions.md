# Regular expressions

In Haxe a [regular expression](https://en.wikipedia.org/wiki/Regular_expression) starts with `~/` and ends with a single `/` and is of type [`EReg`](http://api.haxe.org/EReg.html).

```haxe
var regexp:EReg = ~/world/;

trace(regexp.match("hello world"));
// true : 'world' was found in the string

trace(regexp.match("hello")); 
// false : 'world' is not found in the string
```

Add flags with ending with adding the flag after the ending `/`.

```haxe
var regexp:EReg = ~/world/i; // case insensitive matching

trace(regexp.match("HELLO WORLD"));
// true : 'world' was found in the string
```

Regular expressions with a dynamic pattern can be created by using the `EReg` constructor as follows:

```haxe
var regexp:EReg = new EReg("world", "i"); // case insensitive matching 

trace(regexp.match("HELLO WORLD"));
// true : 'world' was found in the string
```

### Replacing text

Simple text replacement can be done in several ways, even without regular expressions.
Take this example where we replace "hello world" to "happy world":

```haxe
var message = "hello world";
trace(StringTools.replace(message, "hello", "happy"); 
// "happy world"
```

The equivalent using regular expressions would be:

```haxe
var message = "hello world";
var ereg:EReg = ~/hello/;
trace(ereg.replace(message, "happy")); 
// "happy world"
```

Now something what is interesting of regular expressions is that you can search and use the matched result in the replacement.
For example, lets convert "high to low" to "low and high". We search for "high" and anything after that until we find "low". Since we use groups using round brackets, "$1" stands for the first matched group, which is the word "high".

```haxe
var message = "high to low";
var ereg:EReg = ~/(high).+?(low)/;
trace(ereg.replace(message, "$2 and $1")); 
// "high and low"
```

### Iterating on matched parts

Sometimes you want to deal with the specific parts or even the parts left or right of the search:

```haxe
var message = "important note: Haxe is great";
var ereg:EReg = ~/(note:)/;

if (ereg.match(message)) { 
  trace(ereg.matched(1)); // note:
  trace(ereg.matchedLeft()); // important 
  trace(ereg.matchedRight()); // Haxe is great
}
```
> Note that the `match` method modifies the internal state.

The `matchedRight` can be very useful to iterate on the matches in case there are multiple results:


```haxe
var message = "row row row your boat";
var ereg:EReg = ~/(row)/;

while (ereg.match(message)) { 
  trace(ereg.matched(1)); 
  message = ereg.matchedRight();
}
// row
// row
// row
```

In this example we replace using a map function on the message and replace it with the return value of the function:

```haxe
var ereg:EReg = ~/(hello)/i;
var message = "hello world";
trace(ereg.map(message, function(e) return "happy"));
// happy world
```

> **External resources:**
> * An excelent tool to test regular expressions can be found on [regexr.com](http://regexr.com/).
> * More tutorials on regular expressions can be found on [regular-expressions.info](http://www.regular-expressions.info/)
>
> **Haxe resources:**
> * [EReg API documentation](http://api.haxe.org/EReg.html)
> * [Regular Expressions in the Haxe Manual](http://haxe.org/manual/std-regex.html)
