[tags]: / "abstract-type"

# Color as abstract type

> The following example demonstrates how a color type can be abstracted over an integer, which stores the color in an ARGB format.

## Motivation

Color is a good candidate for an abstract type. It can be represented in different formats, but is generally packed into a 32-bit integer made up of four 8-bit color channels: alpha (A), red (R), green (G), and blue (B).

Let's recall that abstract types are a compile-time feature, and are represented by an underlying type at run-time. With that in mind, we can consider creating a `Color` type which will be an `Int` at run-time.

The `Color` type implemented in the example can be directly cast from and to an `Int`, and can be implicitly cast from a `String` representing an ARGB hex value. Color channels can also be set or retrieved in either integer format (in range 0, 255), or floating point format (in range 0, 1).

## Example

```haxe
/**
 * ARGB color type based on a 32-bit integer.
 */
abstract Color(Int) from Int to Int {
  /**
   * Predefined color constants for common colors.
   */
  public static inline var TRANSPARENT : Color = 0x00000000;
  public static inline var BLACK : Color = 0xff000000;
  public static inline var WHITE : Color = 0xffffffff;
  public static inline var RED : Color = 0xffff0000;
  public static inline var GREEN : Color = 0xff00ff00;
  public static inline var BLUE : Color = 0xff0000ff;
  public static inline var CYAN : Color = 0xff00ffff;
  public static inline var MAGENTA : Color = 0xffff00ff;
  public static inline var YELLOW : Color = 0xffffff00;
  
  /**
   * Performs implicit casting from an ARGB hex string to a color.
   * @param   argb  ARGB hex string
   * @return  Color based on hex string
   */
  @:from public static inline function fromString(argb : String) : Color {
    return new Color(Std.parseInt(argb));
  }
  
  /**
   * Creates a new color from integer color components.
   * @param   a   Alpha channel value
   * @param   r   Red channel value
   * @param   g   Green channel value
   * @param   b   Blue channel value
   * @return  Color based on color components
   */
  public static inline function fromARGBi(a : Int, r : Int, g : Int, b : Int) : Color {
    return new Color((a << 24) | (r << 16) | (g << 8) | b);
  }
  
  /**
   * Creates a new color from floating point color components.
   * @param   a   Alpha channel value
   * @param   r   Red channel value
   * @param   g   Green channel value
   * @param   b   Blue channel value
   * @return  Color based on color components
   */
  public static inline function fromARGBf(a : Float, r : Float, g : Float, b : Float) : Color {
    return fromARGBi(Std.int(a * 255), Std.int(r * 255), Std.int(g * 255), Std.int(b * 255));
  }
  
  /**
   * Constructs a new color.
   * @param   argb  Color formatted as ARGB integer
   */
  inline function new(argb : Int) this = argb;
  
  /**
   * Integer color channel getters and setters.
   */

  public var ai(get, set) : Int;
  inline function get_ai() return (this >> 24) & 0xff;
  inline function set_ai(ai : Int) { this = fromARGBi(ai, ri, gi, bi); return ai; }
  
  public var ri(get, set) : Int;
  inline function get_ri() return (this >> 16) & 0xff;
  inline function set_ri(ri : Int) { this = fromARGBi(ai, ri, gi, bi); return ri; }
  
  public var gi(get, set) : Int;
  inline function get_gi() return (this >> 8) & 0xff;
  inline function set_gi(gi : Int) { this = fromARGBi(ai, ri, gi, bi); return gi; }
  
  public var bi(get, set) : Int;
  inline function get_bi() return this & 0xff;
  inline function set_bi(bi : Int) { this = fromARGBi(ai, ri, gi, bi); return bi; }
  
  /**
   * Floating point color channel getters and setters.
   */

  public var af(get, set) : Float;
  inline function get_af() return ai / 255;
  inline function set_af(af : Float) { this = fromARGBf(af, rf, gf, bf); return af; }
  
  public var rf(get, set) : Float;
  inline function get_rf() return ri / 255;
  inline function set_rf(rf : Float) { this = fromARGBf(af, rf, gf, bf); return rf; }
  
  public var gf(get, set) : Float;
  inline function get_gf() return gi / 255;
  inline function set_gf(gf : Float) { this = fromARGBf(af, rf, gf, bf); return gf; }
  
  public var bf(get, set) : Float;
  inline function get_bf() return bi / 255;
  inline function set_bf(bf : Float) { this = fromARGBf(af, rf, gf, bf); return bf; }
}

```
## Usage

```haxe
// Use a predefined color
var red : Color = Color.RED;
// Use a custom color
var fromInt : Color = 0x98765432;
var fromString : Color = "0xffeeddcc";
var fromIntComponents : Color = Color.fromARGBi(255, 125, 100, 50);
var fromFloatComponents : Color = Color.fromARGBf(1.0, 0.3, 0.7, 0.2);
// Access color channels
fromIntComponents.ri = red.ri;
fromString.af = 1.0;
// Print out the hex values
trace(StringTools.hex(red));
trace(StringTools.hex(fromInt));
trace(StringTools.hex(fromString));
trace(StringTools.hex(fromIntComponents));
trace(StringTools.hex(fromFloatComponents));
```

## Compiler output

JavaScript output from Haxe 3.4 with flags `-dce full -D analyzer-optimize` is given below:

```js
var red = -65536;
var fromInt = -1737075662;
var fromString = Std.parseInt("0xffeeddcc");
var fromIntComponents = -8559566;
var fromFloatComponents = (255. | 0) << 24 | (76.5 | 0) << 16 | (178.5 | 0) << 8 | (51. | 0);
fromIntComponents = -39886;
fromString = (255. | 0) << 24 | ((fromString >> 16 & 255) / 255 * 255 | 0) << 16 | ((fromString >> 8 & 255) / 255 * 255 | 0) << 8 | ((fromString & 255) / 255 * 255 | 0);
console.log(StringTools.hex(red));
console.log(StringTools.hex(fromInt));
console.log(StringTools.hex(fromString));
console.log(StringTools.hex(fromIntComponents));
console.log(StringTools.hex(fromFloatComponents));
```

> Learn about Haxe Abstracts here: <http://haxe.org/manual/types-abstract.html>
> 
> Author: [Domagoj Štrekelj](https://github.com/dstrekelj)
