# Base64 encoding

This article shows how to use base64 in Haxe and how to use a custom charset.

```haxe
var myString = "Hello world!";
var encoded = haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(myString));
trace(encoded); // SGVsbG8gd29ybGQh

var decoded = haxe.crypto.Base64.decode(encoded).toString();
trace(decoded); // Hello world!
```

### Customizing charset

As alternative to using the Base64 class as above, it's possible to encode with a custom set of chararacters. Lets use the Base64 chararacters first, which will result in the same as default base64 encoding.
```haxe
var myString = "Hello world!";

var charset = haxe.crypto.Base64.CHARS;
var baseCode = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString(charset));

var encoded = baseCode.encodeString(myString);
trace(encoded);  // SGVsbG8gd29ybGQh

var decoded = baseCode.decodeString(encoded);
trace(decoded); // Hello world!
```

Now lets use a more funky charset. Note that the base length must be a [power of two](https://en.wikipedia.org/wiki/Power_of_two) (1, 2, 4, 8, 16, 32, 64, 128 etc).
In this example we use the four characters `"1ILi"` as charset. The encoded string will be larger, but as expected only contains those characters.
```haxe
var myString = "Hello world!";

var charset = "1ILi";
var baseCode = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString(charset));

var encoded = baseCode.encodeString(myString);
trace(encoded);  // I1L1ILIIILi1ILi1ILii1L11IiIiILiiIi1LILi1ILI11L1I

var decoded = baseCode.decodeString(encoded);
trace(decoded); // Hello world!
```

With this knowledge it is possible to create a Base32 in Haxe; just use `"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"` as charset. Or Base16 would be `"0123456789ABCDEF"`.
```haxe
var myString = "Hello world!";

var charset = "1ILi";
var baseCode = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString(charset));

var encoded = baseCode.encodeString(myString);
trace(encoded);  // I1L1ILIIILi1ILi1ILii1L11IiIiILiiIi1LILi1ILI11L1I

var decoded = baseCode.decodeString(encoded);
trace(decoded); // Hello world!
```
