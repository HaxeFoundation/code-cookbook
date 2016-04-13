[tags]: / "abstract-type,ereg"

#EmailAddress

The following EmailAddress [Abstract type](http://haxe.org/manual/types-abstract.html) example is based on the underlying standard String type, but sets the restriction that it can only represent a valid email address. If not, an exception will be thrown.

```
abstract EmailAddress(String) to String {
  static var ereg  = ~/^[\w-\.]{2,}@[\w-\.]{2,}\.[a-z]{2,6}$/i;
  inline public function new(address:String) {
    if (!ereg.match(address)) throw 'EmailAddress "$address" is invalid';
    this = address.toLowerCase();
  }

  @:from inline static public function fromString(address:String) return new EmailAddress(address);
}
```
## Usage

```
// The following works
var address:EmailAddress = 'eve@paradise.com';
        
// The following throws an exception
var address:EmailAddress = 'adam#paradise.com';

```
> Added by [Jonas Nyström](https://github.com/cambiata)
