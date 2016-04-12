#Email

The following Email [Abstract type](http://haxe.org/manual/types-abstract.html) example is based on the underlying String type, but sets the restriction that it can only represent a valid email address. If not, an exception will be thrown.

```
abstract Email(String) to String {
	inline public function new(email:String) {
		this = email.toLowerCase();
		var ereg  = ~/^[\w-\.]{2,}@[\w-\.]{2,}\.[a-z]{2,6}$/i;
		if (!ereg.match(this)) throw 'Email "$this" is invalid';
	}

	@:from inline static public function fromString(email:String) return new Email(email);
}
```
## Usage

```
// The following works
var mail:Email = 'eve@paradise.com';
        
// The following throws an exception
var mail: Email = 'adam#paradise.com';

```
