[tags]: / "ereg"

# Using regular expressions

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
var regexp:EReg = ~/world/ig; // case insensitive matching + global search

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
trace(StringTools.replace(message, "hello", "happy")); 
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
// "low and high"
```

### Iterating on matched parts

Sometimes you want to deal with the specific parts or even the parts left or right of the search:

Note the `matched` function requires an index. Use `0` to match the whole substring, the index `1` and higher corresponds to the n-th set of parentheses in the regular expression. If no such sub-group exists in the pattern, an exception will be thrown.

```haxe
var message = "important message: Haxe is great";
var ereg:EReg = ~/(message).+?(is)/;

if (ereg.match(message)) { 
  trace(ereg.matched(1)); // message
  trace(ereg.matched(2)); // is
  trace(ereg.matchedLeft()); // important 
  trace(ereg.matchedRight()); //  great
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

More convenient would be to wrap this in a utility function that returns the results as Array. This also allows you to count the results.
```haxe
function getMatches(ereg:EReg, input:String, index:Int = 0):Array<String> {
  var matches = [];
  while (ereg.match(input)) {
    matches.push(ereg.matched(index)); 
    input = ereg.matchedRight();
  }
  return matches;
}

// Test it out
var message = "row row row your boat";
var matches = getMatches(~/(row)/, message);
trace(matches); // [row,row,row]
trace(matches.length); // 3
```

Let's take a more real-life example, you can make an array with objects out of the matches like this:
```haxe
// search for a number, then a space, then everything until newline character or end of input is found
function getFruits(input:String):Array<{amount:Int, fruit:String}> {
  var ereg = ~/(\d{1,2})\s(.+?)(\n|$)/g; 
  var list = [];
  while (ereg.match(input)) {
    list.push({
      amount: Std.parseInt(ereg.matched(1)),
      fruit: ereg.matched(2),
    }); 
    input = ereg.matchedRight();
  }
  return list;
}

// Test it out with a multiline string
var fruits = "1 Apple
	2 Bananas
   	3 Pears
  	1 Tomato";

trace(getFruits(fruits)); 
// [{amount:1, fruit:Apple}, {amount:2, fruit:Bananas}, {amount:3, fruit:Pears}]
```

#### Mapping results
In the following example we replace each match on a string using the `EReg.map` function and trace the replaced output.

```haxe
var ereg:EReg = ~/(hello)/i;
var message = "hello world";
trace(ereg.map(message, function(e) return "happy"));
// happy world
```

> **External resources:**
>
>  * An excellent tool to test regular expressions can be found on [regexr.com](http://regexr.com/).
>  * More tutorials on regular expressions can be found on [regular-expressions.info](http://www.regular-expressions.info/)
>
> **Haxe resources:**
>
>  * [EReg API documentation](http://api.haxe.org/EReg.html)
>  * [Regular Expressions in the Haxe Manual](http://haxe.org/manual/std-regex.html)
