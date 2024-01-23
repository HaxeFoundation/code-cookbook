[tags]: / "externs,hxcpp"

# Hxcpp Pointers

This page covers the differences and use cases of the three main pointer types; `cpp.ConstRawPointer` and `cpp.RawPointer`, `cpp.ConstPointer` and `cpp.Pointer`, and `cpp.Star`.

## cpp.RawPointer

As the name says, just bog standard c pointers. e.g. the following haxe function

```haxe
function foo(cpp.RawPointer<int> bar) {}
```

will produce the following C++ function

```cpp
void foo(int* bar) {}
```

No special magic going on here. The `cpp.RawPointer`s can also be used like arrays from the haxe side making them very useful for representing c arrays. e.g. The following c++ struct

```cpp
struct Foo {
  uint8_t bar[5];
};
```

could be externed with the following haxe class and the `foo` variable could be indexed like a standard haxe array.

```haxe
extern class Foo {
  var cpp.RawPointer<cpp.UInt8> bar;
}
```

The downside with these is that its not ergonomic from a haxe pov to represent and consume pointers to objects.

```haxe
extern class Foo {
  function bar():Int;
}

function myFunc(foo:cpp.RawPointer<Foo>) {
  // Have to use [0] ...
  trace(foo[0].bar());
}
```

They also cannot be used in any situations where Dynamic is expected (explicitely or implicitly).

```haxe
Array<cpp.RawPointer<int>> // Will generate code which gives C++ compiler errors.
```

## cpp.Pointer

Similar to the above, but with some key differences. The code they generate does not map directly to pointers, but instead to a special `::cpp::Pointer<T>` struct.

```haxe
function foo(cpp.Pointer<int> p) {}
```

```cpp
void foo(::cpp::Pointer<int> p) {}
```

This type lives on the stack so does not contribute to GC pressure, it also is compatible with Dynamic, so you can pass `cpp.Pointer` types into dynamic places and use them with generic arguments. This type also contains loads of convenience functions for reinterpreting the pointer, arithmetic, conversions to haxe arrays and vectors, etc, etc. There are also member fields for accessing the `cpp.Pointer` as a `cpp.RawPointer` or `cpp.Star`.

It also retains the array access that `cpp.RawPointer` does. On top of this the `::cpp::Pointer` type has implicit to and from conversions for the underlying pointer, which means you can extern the following function

```cpp
void foo(int* v) {}
```

with this haxe function

```haxe
void foo(v:cpp.Pointer<Int>) {}
```

You don't need to use `cpp.RawPointer` here, you can use `cpp.Pointer` and all the convenience it provides. So why would you ever want to use `cpp.RawPointer` if `cpp.Pointer` does everything it does and is compatible with more of haxe's type system.

Function signatures.

`cpp.Pointer` is an actual C++ class implemented in the hxcpp runtime, so if you had the following c function which takes in a function pointer.

```c++
typedef void(*bar)(int*)

void foo(bar func) {}
```

you could not use the following haxe function to generate a function pointer to pass into it.

```
function haxe_foo(cpp.Pointer<int> v) {}

function main() {
  cpp.Callable.fromStaticFunction(haxe_foo);
}

```

That `fromStaticFunction` call will generate a function pointer with the signature of `void(*)(::cpp::Pointer<int>)` which is not compatible with the function pointer `bar`.

## cpp.Star

This is the last pointer types and like `cpp.RawPointer` it generates raw C pointers in the output code, the key difference is that this type does not support array access and will auto de-reference when accessing the underlying data. This means it's ideal for representing pointers to objects. E.g. the following C++

```c++
struct Bar {
  int baz();
};

bar* foo();
```

could be externed using `cpp.Star` to make calling the `baz` function more ergonomic.

```haxe
extern class Bar {
  function baz():Int;
}

extern function foo():cpp.Star<Bar>;

function main() {
  final bar = foo();

  trace(bar.baz());
}
```

No weird `[0]` like you would need to with `cpp.RawPointer` and since it is an actual pointer it can be used in function signatures unlike `cpp.Pointer`.
However, like `cpp.RawPointer` it is not compatible with Dynamic. But as previously mentioned `cpp.Pointer` has functions for wrapping a `cpp.Pointer` and accessing its underlying pointer as a `cpp.Star` so you can get the best of all worlds with `cpp.Pointer`.
