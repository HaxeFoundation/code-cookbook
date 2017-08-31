[tags]: / "enum, pattern-matching, data-structures"

# Pattern matching

This article helps to learn the syntax used in pattern matching to learn working with switch cases in practise. 

Switch statements in Haxe can improve readability and also help write less repetitive / redundant code. 
You might have found code in the macro section and wonder what all those switches do, or what the difference would be compared to if/else statements.
Some examples on this page don't improve readability directly, they are mostly to explain the syntax and demonstrate how pattern matching works. 
At the end of the article there will be cases where its usecase will be more clear and readability/expressiveness is considered better compared to using plain if/else statements.

To get started with [pattern matching in Haxe](https://haxe.org/manual/lf-pattern-matching.html), please consult the manual too.

### Basic matching and capturing variables

Let's say we loop from 0 to 10 and log if we found a special number two or four.

```haxe
for (value in 0...10) {
  switch value {
    case 2: 
      trace("special number 2");
    case 4: 
      trace("special number 4");
    case _: 
      trace("other");
  }
}
```
The underscore here means "anything" and works basically the same as `default` in this case. But it does not have a name assigned. This means you can't log it or pass it to something else for example.

Now imaging we want to log what the "other number" actually is. 
This can be done using [variable capture](https://haxe.org/manual/lf-pattern-matching-variable-capture.html). In our case we name it to `other`.

```haxe
for (value in 0...10) {
  switch value {
    case 2: 
      trace("special number 2");
    case 4: 
      trace("special number 4");
    case other: 
      trace("other: " + other);
  }
}
```

*Important note:* The order of the cases are important. For the sake of clarity, this will never log any special number, because it will match the "others" pattern first.
Luckily, if we do write this, Haxe will give a compiler warning "This case is unused", since it knows it will never match our special numbers.

```haxe
for (value in 0...10) {
  switch value {
    case other: 
      trace("other: " + other);
    case 2:
      trace("special number 2");
    case 4:
      trace("special number 4");
  }
}
```

Let's continue with the naming. Of course we can also name our special number and capture that as variable. 
Remember that a great feature of pattern matching is that you can name anything. This helps avoiding repeating code.

```haxe
for (value in 0...10) {
  switch value {
    case special = 2: 
      trace("special number: " + special);
    case other: 
      trace("other: " + other);
  }
}
```

### Or pattern

The `|` operator can be used anywhere within patterns to describe multiple accepted patterns. If there is a captured variable in an or-pattern, it must appear in both its sub-patterns. 

Let's go on with the previous example and say that not only 2 and 4 are special, but 6 is too. You can switch on multiple cases like this:

```haxe
for (value in 0...10) {
  switch value {
    case 2 | 4 | 6: 
      trace("special number");
    case other: 
      trace("other: " + other);
  }
}
```

Again it is possible to capture our special numbers into a variables. 

```haxe
switch Std.random(10) {
  case special = 2 | 4 | 6: 
    trace("special number: " + special);
  case other:
    trace("other: " + other);
}
```

> You can use commas to use multiple case. So `case 2, 4, 6` is the same as writing <code>case 2 &#124; 4 &#124; 6</code>. 
> Comma is the old notation from Haxe 2, but still works. But because of Haxe's internal structure, commas separate patterns which disallows variable capturing since you can't do `a = 2,4,6`.

### Matching on the result of a function 

To continue learning about what we can do with pattern matching let's trace if a value is even or odd. 
Without pattern matching you would create an if/else condition like this.

```haxe
function isEven(value:Float) return value % 2 == 0;

for (value in 0...10) {
  if (isEven(value)) {
    trace("even");
  } else {
    trace("odd");
  }
}
```

With pattern matching you could switch on the result of the isEven function, which is either `true` or `false`.

```haxe
function isEven(value:Float) return value % 2 == 0;

for (value in 0...10) {
  switch isEven(value) {
    case true: 
      trace("even");
    case false: 
      trace("odd");
  }
}
```

### Extractors

[Pattern matching extractors](https://haxe.org/manual/lf-pattern-matching-extractors.html) are identified by the `case expression => pattern:` syntax. Extractors consist of two parts, which are separated by the => operator.

 * The left side can be any expression, where all occurrences of underscore `_` are replaced with the currently matched value.
 * The right side is a pattern which is matched against the result of the evaluation of the left side.

Don't let the underscores confuse you. In extractors (when there's `=>`), `_` has a special meaning: the currently matched value. 

Let's do a very simple example of an extractor first; check if the matched value is 2.

```haxe
for(value in 0...10) {
  switch input {
    case _ => 2:
      trace("found special number");
  }
}
```

Now let's bring in a functions and capture the result as variable.

```haxe
function add(a:Int, b:Int) return a + b;

var input = 3;

switch input {
  case add(_, 1) => result:
    trace(result);
    // add(3 + 1)
    // 1 + 3 = 4
}
```

Let's a more complex expression by using two functions: `mul(add(3 + 1), 3)`, which will result in 12 because `(3+1)*3=12`.

```haxe
function add(a:Int, b:Int) return a + b;
function mul(a:Int, b:Int) return a * b;

var input = 3;

switch input {
  case mul(add(_, 1), 3) => result:
    trace(result);
    // mul(add(3 + 1), 3)
    // 1 + 3 = 4, => 4 * 3 = 12
}
```

Sometimes it's easier to read complex patterns like that once you know that extractors are just a kind of pattern.
So given that extractor is `<expr> => <pattern>`, you can nest extractors like `<expr> => (<expr> => <pattern>)`.

The following example "chains" two extractors.

```haxe
function add(a:Int, b:Int) return a + b;
function mul(a:Int, b:Int) return a * b;

var input = 3;

switch input {
  case add(_, 1) => mul(_, 3) => result:
    trace(result);
    // mul(add(3 + 1), 3)
    // 1 + 3 = 4, => 4 * 3 = 12
}
```
> In the examples above we actually do not match anything, but if we would use `case add(_, 1) => mul(_, 3) => 12:` instead of `value`, it will only match if the result is 12.

Now back to the odd/even check. The following example doesn't improve readability but demonstrates how we also could have used extractors.
The function `isEven` returns a `Bool`, which we use to match on.

```haxe
function isEven(value:Float) return value % 2 == 0;

for (value in 0...10) {
  switch value {
    case isEven(_) => true: 
      trace("even");
    case _: 
      trace("odd");
  }
}
```

Now let's wrap it up and combine our odd/even check and capture all as variables and log them. We loop from 0 to 10 and number 4 is our special number.

```haxe
function isEven(value:Float) return value % 2 == 0;

for (value in 0...10) {
  switch value {
    case special = 4: 
      trace("special number: " + special);
    case value = isEven(_) => true: 
      trace("even number: " + value);
    case other:
      trace("other: " + other);
  }
}
```

This will log:

```
even number: 0
other: 1
even number: 2
other: 3
special number: 4
other: 5
even number: 6
other: 7
even number: 8
other: 9
```

### Array matching

With [array pattern matching](https://haxe.org/manual/lf-pattern-matching-array.html) you can switch on multiple cases at the same time.
This makes the cases easier to read and compare.

```haxe
for(input1 in 0...4) {
  for(input2 in 0...4) {
    switch [input1, input2] {
      case [1, 1]: trace("one and one");
      case [1, 2]: trace("two and two");
      case [2, _]: trace("two and something else");
      case [_, _]: trace("other", input1, input2);
    }
  }
}
```

The "Fizz-Buzz test" is an interview question designed to help filter out the 99.5% of programming job candidates who can't seem to program their way out of a wet paper bag.
The text of the programming assignment is as follows:

> "Write a program that prints the numbers from 1 to 100. But for multiples of three print “Fizz” instead of the number and for the multiples of five print “Buzz”. For numbers which are multiples of both three and five print “FizzBuzz”."

Without pattern matching a programmer could write the code like this:

```haxe
function isMultipleOf(value:Float, of:Float):Bool return value % of == 0;

for (value in 1...101) { // from 1 to 100
  var multipleOf3 = isMultipleOf(value, 3);
  var multipleOf5 = isMultipleOf(value, 5);
  if (multipleOf3 && multipleOf5) {
    trace("FizzBuzz");
  } else if (multipleOf3) {
    trace("Fizz");
  } else if (multipleOf5) {
    trace("Buzz");
  } else {
    trace(Std.string(value));
  }
}
```

We could rewrite this to something that switches on one of the two variables and check if those are true.
If you remembered that extractors are `<expr> => <pattern>` it is possible to use `&&` in our first case.

```haxe
function isMultipleOf(value:Float, of:Float):Bool return value % of == 0;
    
for(value in 1...101) {
  var multipleOf3 = isMultipleOf(value, 3);
  var multipleOf5 = isMultipleOf(value, 5);
  trace(switch value {
    case multipleOf3 && multipleOf5 => true: "FizzBuzz";
    case multipleOf3 => true: "Fizz";
    case multipleOf5 => true: "Buzz";
    case _: Std.string(value);
  });
}
```

If we would have use array matching here, our FizzBuzz code would look like:

```haxe
function isMultipleOf(value:Float, of:Float):Bool return value % of == 0;

for(value in 1...101) {
  trace(switch [isMultipleOf(value, 3), isMultipleOf(value, 5)] {
    case [true, true]: "FizzBuzz";
    case [true, false]: "Fizz";
    case [false, true]: "Buzz";
    case [false, false]: Std.string(value);
  });
}
```

### Rock / Paper / Scissors

Let's go into real live examples of array matching. They become powerful when bringing enums and more complex objects.
Now readability is always debatable but this example shows how clear you can create a rock paper scissors game with array matching.
Writing this code with if/else would have lot of `if(playerA.move == Paper && playerB.move == Paper) winner = playerB`. But as you can see the switch here directly returns the player who wins, or `null` when it is draw.

```haxe
class Test {
  static function main() {
    var playerA = {
      name: "Simn",
      move: Move.Paper
    }
    var playerB = {
      name: "Nicolas",
      move: Move.Rock
    }
        
    // a switch can directly return something
    var winner = switch [playerA.move, playerB.move] {
      case [Rock, Paper]: playerB;
      case [Rock, Scissors]: playerA;
      case [Paper, Rock]: playerA;
      case [Paper, Scissors]: playerB;
      case [Scissors, Rock]: playerB;
      case [Scissors, Paper]: playerA;
      default: null;
    }
    
    if (winner != null) {
      trace('The winner is: ${winner.name}');
    } else {
      trace('Draw!');
    }
  }
}  

enum Move {
  Rock; Paper; Scissors;
}
```

### Parsing input

Pattern matching can also be very useful when you want to parse/match input, e.g. for a text based game, bot or when building a command-line interface (CLI).
In the following example we want to parse `"say {word} to {name}"`. If the input doesn't match, it says "unknown command". As you can see we use array matching and capture {word} and {name} as variables.

```haxe
var input = "say hello to Dave";

switch input.split(" ") {
	case ["say", word, "to", name]: 
		trace('"$word" to $name');
	case _: 
		trace("unknown command");
}
// "hello" to Dave
```

Of course you can bring the multiple cases here in too.
Let's say our bot is a bit picky and only replies when you say something to Sophia, Emma or Olivia:

```haxe
var input = "say hi to Mark";

switch input.split(" ") {
	case ["say", word, "to", name = "Sophia" | "Emma" | "Olivia"]: 
		trace('I only want to say "$word" to you, $name');
	case _: 
		trace("unknown command");
}
```

### Guards

It is possible to restrict case using if statements. We call these [guards](https://haxe.org/manual/lf-pattern-matching-guards.html). They can be used with the `case ... if(condition):` syntax.
For example, suppose you want to check whether an integer is greater than, less than, or equal to zero.

```haxe
var value = 10;
if (value > 0) {
  print("positive: " + value);
} else if (value < 0) {
  print("negative: " + value);
} else {
  print("zero");
}
```

The equivalent of this with guarded pattern matching would be the following snippet. 
As you might notice we will capture a variable of value in the case (`case v`) and use `v` in the if-statement afterwards.

```haxe
var value = 10;
switch value {
  case v if (v > 0): 
    trace("positive: " + v);
  case v if (v < 0): 
    trace("negative: " + v);
  case _: 
    trace("zero");
}
```

Now combine what we learned already learned so far and go back to our input command bot and make the input accept these cases:

 - `"say {word}"`. 
 - `"say {word} to {name}`. When you use the {name} Sophia/Emma/Olivia it replies different.
 - `"say {word} {amount} times"`. {word} should be hello/hi/hey and {amount} should be a number.
 
Since we are dealing with strings the example uses a regexp `^[0-9]+$` to validate if there is a number in the string, afterwards we parse it to an actual integer using `Std.parseInt`.
As might want to figure out, the following example would be hard to do with if/else statements.

```haxe
var input = "say hello 3 times";

switch input.split(" ") {
  case ["say", word]: 
    trace(word);
  
  case ["say", word, "to", name = "Sophia" | "Emma" | "Olivia"]: 
    trace('I only say $word to you, $name');
  
  case ["say", word, "to", name]: 
    trace('$word to $name');
  
  case [action = "say", word = "hello"|"hi"|"hey", amount, "times"] if (~/[0-9]{1,}/.match(amount)): 
    for (i in 0 ... Std.parseInt(amount)) {
      trace('$action $word');
    }
  
  case _:
    trace("unknown command");
}
```
