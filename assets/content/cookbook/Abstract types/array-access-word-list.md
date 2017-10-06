[tags]: / "abstract-type"

# Array access of words in a sentence

Abstract types are very useful for layering strongly-typed functionality over top of more basic classes. They are also the only place where operator overloading (including array access). In this relatively trivial example, we can make use of the `@:arrayAccess` metadata to allow us to easily access individual words in a sentence (where word boundaries are defined as spaces).

First off, we can describe an abstract over a string, which will define a new type that is 100% a string:

```haxe
abstract WordList(String) from String to String {
  public function new(s:String)
    this = s;
}
```

This is a bit useless on it's own however, so let's add the `@:arrayAccess` components we're actually after:

```haxe
abstract WordList(String) from String to String {
  public function new(s:String)
    this = s;

  @:arrayAccess
  public inline function getWord(index:Int) {
    return this.split(' ')[index];
  }

  @:arrayAccess
  public inline function setWord(index:Int, word:String) {
    var words:Array<String> = this.split(' ');
    words[index] = word;
    return this = words.join(' ');
  }
}
```

These two functions (`getWord` and `setWord`) are simple inline functions for extracting or replacing a word in a sentence, and could be called as:

```haxe
var thirdWord = sentence.getWord(2);
sentence.setWord(1, "moderately-paced");
```

However, this is a bit verbose. The `@:arrayAccess` metadata allows us to instead call the functions as:

```haxe
var thirdWord = sentence[2];
sentence[1] = "moderately-paced";
```

## Usage

```haxe
var sentence:WordList = "The quick brown fox jumped over the lazy dog's back.";

Sys.println('In the sentence:');
Sys.println(' > ' + sentence);
Sys.println('');

Sys.println('What colour is the fox?');
Sys.println(' > ' + sentence[2]);
Sys.println('');

Sys.println("Let's slow him down...");
sentence[1] = "moderately-paced";
Sys.println(' > ' + sentence);
```

This will print:

```
In the sentence:
 > The quick brown fox jumped over the lazy dog's back.

What colour is the fox?
 > brown

Let's slow him down...
 > The moderately-paced brown fox jumped over the lazy dog's back.
```

> More on this topic: 
> 
> * [Array Access in Haxe Manual](https://haxe.org/manual/types-abstract-array-access.html)
> 
> Author: [Kenton Hamaluik](https://github.com/FuzzyWuzzie/)