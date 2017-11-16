[tags]: / "enum, pattern-matching, data-structures"

# Pattern matching

This article helps to learn pattern matching and all of its type of matching in practice. The article covers basic matching, variable capture, guards, extractors and enum/structure matching.

Switch statements in Haxe can improve readability and also help write less repetitive / redundant code. 
You might have found code in the macro section and wonder what all those switches do, or what the difference would be compared to if/else statements.
Some examples on this page don't improve readability directly, they are mostly to explain the syntax and demonstrate how pattern matching works. 
At the end of the article there will be cases where its usecase will be more clear and readability/expressiveness is considered better compared to using plain if/else statements.

To get started with pattern matching in Haxe, please consult [the manual](https://haxe.org/manual/lf-pattern-matching.html) too.

### Basic matching and capturing variables

Let's say we loop from 0 to 10 and log if we found a special number two or four.

The matches can be written like `case <pattern>:`

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
This can be done using [variable capture](https://haxe.org/manual/lf-pattern-matching-variable-capture.html). In our case we name it `other`.

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

*Important note:* The order of the cases are important. For the sake of clarity, the following code will never log any special number, because it will match the "others" pattern first.
Luckily, if we do write such [useless cases](https://haxe.org/manual/lf-pattern-matching-unused.html), Haxe will give a compiler warning "This case is unused", since it knows it will never match our special numbers.

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
  switch value {
    // match if value equals two
    case _ => 2:
      trace("found special number");
  }
}
```

Now let's bring in a function and capture the result as variable.

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
    // match even numbers
    case isEven(_) => true: 
      trace("even");

    // match anything
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
    // match number 4
    case special = 4: 
      trace("special number: " + special);

    // match even numbers
    case value = isEven(_) => true: 
      trace("even number: " + value);

    // match anything
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

### Matching on multiple values

It's possible to [match on multiple values](https://haxe.org/manual/lf-pattern-matching-tuples.html), by using `switch [expr, expr, ..]` which uses array syntax.
The cases should contain an array of the same length. This type of matching makes it easier to compare values between cases.

This will trace 1 because `array[1]` matches 6, and `array[0]` is allowed to be anything.
```haxe
var myArray = [1, 6];
switch(myArray) {
  case [2, _]: 
    trace("0");
  case [_, 6]:
    trace("1");
  case []: 
    trace("2");
  case [_, _, _]: 
    trace("3");
  case _: 
    trace("4");
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

If we would match using multiple values here, our FizzBuzz code would look like demonstrated here. We basically do `switch [boolean, boolean]` here.

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

Let's go into more practical examples of array matching. They become powerful when bringing enums and more complex objects.
Now readability is always debatable but this example shows how clear you can create a rock paper scissors game with matching multiple values.
Writing this code with if/else would have lot of `if(playerA.move == Paper && playerB.move == Paper) winner = playerB`. 
As you can see the switch here directly returns the player who wins, or `null` when it is draw.

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
If we would use the OR pattern here, we could have written the cases like this:
```
var winner = switch [playerA.move, playerB.move] {
  case [Rock, Scissors] | [Paper, Rock] | [Scissors, Paper]: playerA;
  case [Rock, Paper] | [Paper, Scissors] | [Scissors, Rock]: playerB;
  default: null;
}
```

### Array matching

[Array matching](https://haxe.org/manual/lf-pattern-matching-array.html) is looks similar to matching on multiple values, but this matches on actual arrays, not on multiple things which can be different types. 
The cases can have different array length.
It can also be very useful when you want to parse/match input, e.g. for a text based game, bot or when building a command-line interface (CLI).
In the following example we want to parse `"say {word} to {name}"`. If the input doesn't match, it says "unknown command". As you can see we capture {word} and {name} as variables.

```haxe
var input = "say hello to Dave";

switch input.split(" ") {
  // match "say {word} to {name}"
  case ["say", word, "to", name]: 
    trace('$word to $name');

  // match anything
  case _: 
    trace("unknown command");
}
// hello to Dave
```

Of course you can bring the multiple cases here in too.
Let's say our input command bot is a bit picky and replies different when you say specific to somebody called Sophia, Emma or Olivia. 
Note that because the given name here is Mark, it will fall to the second case.

```haxe
var input = "say hi to Mark";

switch input.split(" ") {
  // match "say {word} to {name}" where name is specific name
  case ["say", word, "to", name = "Sophia" | "Emma" | "Olivia"]: 
    trace('I only want to say $word to you, $name');

  // match "say {word} to {name}"
  case ["say", word, "to", name]: 
    trace('$word to $name');

  // match anything
  case _: 
    trace("unknown command");
}
```

### Guards

It is possible to restrict case using if statements. We call these [guards](https://haxe.org/manual/lf-pattern-matching-guards.html). 
They can be used with the `case ... if(condition):` syntax.
For example, suppose you want to check whether an integer is greater than, less than, or equal to zero.

```haxe
var value = 10;
if (value > 0) {
  trace("positive: " + value);
} else if (value < 0) {
  trace("negative: " + value);
} else {
  trace("zero");
}
```

The equivalent of this with guarded pattern matching would be the following snippet. 
As you might notice we will capture a variable of value in the case (`case v`) and use `v` in the if-statement afterwards.

```haxe
var value = 10;
switch value {
  // match if v is bigger than 0
  case v if (v > 0): 
    trace("positive: " + v);

  // match if v is smaller than 0
  case v if (v < 0): 
    trace("negative: " + v);

  // matches anything
  case _: 
    trace("zero");
}
```

Now let's again combine what we learned already learned so far and go back to our input command bot and make the input accept these cases:

 - `"say {word}"`. 
 - `"say {word} to {name}"`. When you use the {name} Sophia/Emma/Olivia it replies different.
 - `"say {word} {amount} times"`. {word} should be hello/hi/hey and {amount} should be a number.
 
Since we are dealing with strings the example uses a regexp `^[0-9]+$` to validate if there is a number in the string, afterwards we parse it to an actual integer using `Std.parseInt`.
As you can imagine, the following example would be hard to do with if/else statements.

```haxe
var input = "say hello 3 times";

switch input.split(" ") {
  // match "say {word}"
  case ["say", word]: 
    trace(word);

  // match "say {word} to {name}" where name is specific name
  case ["say", word, "to", name = "Sophia" | "Emma" | "Olivia"]: 
    trace('I only say $word to you, $name');

  // match "say {word} to {name}"
  case ["say", word, "to", name]: 
    trace('$word to $name');

  // match "say {word} {amount} times" where {word} is a greeting and {amount} is a number.
  case [action = "say", word = "hello"|"hi"|"hey", amount, "times"] if (~/[0-9]{1,}/.match(amount)): 
    for (i in 0 ... Std.parseInt(amount)) {
      trace('$action $word');
    }

  // matches anything
  case _:
    trace("unknown command");
}
```

### Matching on structures

The next flavour of pattern matching is [matching on structures and instances](https://haxe.org/manual/lf-pattern-matching-structure.html).
These matches can be written like `case { key: <pattern>, key: <pattern>, ..}:`.

In the following example we match on these rules:

1. Find someone who is older than 50
1. Otherwise find someone named Jose who is 42
1. Otherwise, log the name

As you may notice we use capture variables,

```haxe
var person = { name: "Mark", age: 33 };

switch person {
  // match person with age older than 50
  case { age: _ > 50 => true}:
    trace('found somebody older than 50');

  // match on specific person named Jose who is 42
  case { name: "Jose", age: 42  }:
    trace('Found Jose, who is 42');

  // match on name
  case { name: name }:
    trace('Found someone called $name');

  // matches anything
  case _:
    trace("unknown");
}
```
If we would like to trace the age of the person in the first case we could have written `case { age: age > 50 => true}: trace('found somebody older than 50, the age is $age')`.

Of course object matching can be used with all other things we already used before.

```haxe
var person1 = { name: "Mark", age: 33 };
var person2 = { name: "John", age: 45 };

switch [person1, person2] {
  // match if person1 is older than person2
  case [{name:name1, age:age1}, {name:name2, age:age2}] if (age1 > age2):
    trace('name1 is older than $name2');

  // match on both persons names
  case [{name:name1}, {name:name2}]:
    trace('name1 is youngher than $name2');
}
```

### Enum matching

Haxe provides a powerful [enumeration type](https://haxe.org/manual/types-enum-instance.html) (enum), which are an algebraic data type (ADT). 
They are very useful for describing data structures and work nicely with pattern matching.
We continue to the next flavour of pattern matching: [matching on enums](https://haxe.org/manual/lf-pattern-matching-enums.html). 

The matches can be written like `case Enum(<pattern>, <pattern>, ..):` depending on the amount of parameters the enum has. 
Of course the pattern may contain variable capture, extractors and match structures and can be restricted with guards etc. 


```haxe
class Game {
  static function main() {
    var event = WIN(1000);

    switch (event) {
      case START: 
        trace('Game started');

      case LOST:
        trace('Game over. You lost..');

      case WIN(score):
        trace('Game over. You win! Score: $score!');
    }
  }
}

enum GameEvent {
  START;
  LOST;
  WIN(score:Int);
}
```

A nice thing to know is that "nested" enum instances can be matched in one case, which saves a lot of nested switches or if-conditions otherwise. 
The syntax could be `case Enum(Enum(<pattern>, Enum(<pattern>), ..), <pattern>, ..):`, again depending on the amount of parameters the enum has. For example, the Haxe macro printer matches expressions that are constant (EConst) Strings (CString) in one pattern: `case EConst(CString(s)):`

In the following (more complex) example, a `Tree` enum consists of `Node`s and `Leaf`s, where `Node` has a left and right subtree. This way you can make a big structure, since you can keep on nesting. It is possible to use enum matching to match structures within this tree:

```haxe
class Test {
  static function main() {
    var myTree = Node(
      Leaf("RED"), 
      Node(Leaf("ORANGE"), Leaf("GREEN"))
    );

    //              Node
    //           /        \
    //  Leaf("RED")        Node
    //                    /     \
    //         Leaf("ORANGE")  Leaf("GREEN")

    var match = switch(myTree) {
      // matches any Node that has a Leaf on right-side
      case Node(_, Leaf(name)): 'Node with leaf: $name';

      // matches any Node that has another Node on right-side 
      // which has Leaf("{name}") on left-side
      // where name is uppercase
      case Node(_, Node(Leaf(name), _)) if (name.toUpperCase() == name): 'Node with Node with leaf: $name';

      // matches any Node that has another Node on right-side 
      // which has Leaf("{name}") on left-side
      case Node(_, Node(Leaf(name), _)): 'Node with Node with leaf: (case sensitive) $name';

      // matches anything
      case _: 'unknown';
    }

    trace(match); // "Node with Node wih leaf: ORANGE"
  }
}

enum Tree<T> {
  Leaf(v:T);
  Node(l:Tree<T>, r:Tree<T>);
}
```
