[tags]: / "abstract-type,type-params,iterator"

# Working Around Iterators as a Generic Type Parameter

[Iterators](https://haxe.org/manual/lf-iterators.html) are a helpful Haxe structure. They allow you to build a for loop, but sometimes you want to do something a bit more complex, like iterating over a list of items over time, which excludes the possibility of using a for loop. Ideally you would build a generator function, but Haxe does not have these out of the box. There are libraries that allow you to do this, though, like [moon-core](https://lib.haxe.org/p/moon-core/1.0.0/).

However, Iterator is a structure, which is a limitation when you want to use it as the parameter for a generic type. For example, haxe.ds.[GenericStack](http://api.haxe.org/haxe/ds/GenericStack.html)<Iterator<Int>> is an interesting piece of code. It will compile for an html5 target, given Javascript's extreme type flexibility, but it will not compile for other targets, including Flash. The compiler will display the following error:

```
Type parameter must be a class or enum instance (found { next : Void -> Int, hasNext : Void -> Bool })
```

You could try *typedef*ing the Iterator, but for type purposes, Iterator is still a structure, and not a class or enum instance. You could write a class that wraps an Iterator, even parametize it; but it means writing a lot of unnecesary boilerplate code.

This is when an abstract type is the perfect wrapper, and it's just 5 lines of code (assuming braces do not belong in a newline, your call):

```haxe
@:forward(hasNext, next)
abstract AbstractIterator<T>(Iterator<T>) {
	inline public function new(iterator:Iterator<T>) {
		this = iterator;
	}
}
```

Abstract types are simply a way of specializing a type. For the purposes of the compiler, it's a type, but at the moment of generating the target code, the wrapper is discarded and it generates the same code as it would for the wrapped type. In this case, we are wrapping the Iterator, and we're also forwarding the two methods of Iterator, hasNext and next, instead of rewriting them as inline public functions.

We can start using AbstractIterator inside our GenericStack

```haxe
intStack = new GenericStack<AbstractIterator<Int>>();
intStack.add(new AbstractIterator(gimme_an_array_of_ints().iterator()));
var intStackHasNext = intStack.first().hasNext();
var intStackNext = intStack.first().next();
```

Remember this is only necessary if you are targeting some other platform than html5, but it also shows you the power of abstract types in Haxe, and how could you use them to specialize basic types.
