[tags]: / "abstract-type"

# Temperature units as abstract type

The following Celcius and Fahrenheit [Abstract types](http://haxe.org/manual/types-abstract.html) are based on the underlying `Float` type, but sets the restriction that it can never hold values below absolute zero. 

Also, the `@:to` [field casts](http://haxe.org/manual/types-abstract-implicit-casts.html) take care of automatically converting from one unit to the other.

```haxe
abstract Celcius(Float) to Float {    
  inline function new(value : Float)  
    this = Math.max(value, -273.15);
    
  @:from inline static public function fromFloat(value : Float) : Celcius
    return new Celcius(value);    
    
  // the following field cast automatically converts to Fahrenheit from Celcius
  @:to inline public function toFahrenheit() : Fahrenheit    
    return (this / 5 * 9) + 32;   
}

abstract Fahrenheit(Float) to Float {    
  inline function new(value : Float)  
    this = Math.max(value, -459.67);
    
  @:from inline static public function fromFloat(value : Float) : Fahrenheit
    return new Fahrenheit(value);      
  
  // the following field cast automatically converts to Celcius from Fahrenheit
  @:to inline public function toCelcius() : Celcius
    return (this - 32) * 5 / 9;
}
```

## Usage

```haxe
// Here we start by defining a temperature in Celcius
var waterfreezeC:Celcius = 0;
trace('Water freezes at $waterfreezeC degrees Celcius.');   

// Please note the unit conversion in the following line, automatically 
// invoking the Celcius.toFahrenheit() method for us:
var waterfreezeF:Fahrenheit = waterfreezeC;        
trace('Water freezes at $waterfreezeF degrees Fahrenheit.');   
```

## Credits to Franco Ponticelli

This example is inspired by [Franco Ponticelli's](https://github.com/fponticelli) [**Thx.Unit**](https://github.com/fponticelli/thx.unit) library.
There, you can find lots of interesting examples of well written code using abstract types. 
To point out one intersting thing: In thx.unit, the temperature abstracts are based on another abstract type - Decimal - for greater floating point accuracy.

> Learn about Haxe Abstracts here: <http://haxe.org/manual/types-abstract.html>
> 
> Author: [Jonas Nyström](https://github.com/cambiata)

