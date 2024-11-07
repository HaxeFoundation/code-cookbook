[tags]: / "autobuild-macro,building-fields"

# Autobuild fields from enum type param

This macro function adds fields corresponding to an extended type's enum type param.

```haxe
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using haxe.macro.Tools;

class Macro {
  public static function buildSet():Array<Field> {
    final fields = Context.getBuildFields();
    
    try {
      return switch Context.getLocalType() {
        // Extract the type parameter
        case TInst(getEnumType(_.get()) => enumType, _):
          // Generate fields
          addFields(enumType, fields);

          fields;
        case found:
          throw 'Expected TInst, found: $found';
      }
    } catch(e) {
      // Catch thrown errors and point them to the failing class
      Context.error(e.message, Context.currentPos());
      return Context.getBuildFields();
    }
  }

  static function getEnumType(local:ClassType):EnumType {
    return switch local.superClass.params {
      case [_.follow() => param]:
        switch param {
          case TEnum(type, []):
            type.get();
          case TEnum(_, _):
            throw "Enums with type params are not allowed";
          case found:
            throw 'T must be an Enum type, found: $found';
        }
      case found:
        throw 'Expected <T:EnumValue>, found: $found';
    }
  }

  static function addFields(enumType:EnumType, fields:Array<Field>) {
    // Add a getter for each enum value
    for (name => field in enumType.constructs) {
      // Determine the full path of the enum field
      final path = enumType.module.split(".");
      path.push(enumType.name);
      path.push(field.name);

      // Create a getter that calls has() with the corresponding enum field
      final getterName = 'get_$name';
      final newFields = (macro class TempClass {
        public var $name(get, never):Bool;

        @:noCompletion inline function $getterName() return has($p{path});
      }).fields;
      fields.push(newFields[0]);
      fields.push(newFields[1]);
    }
  }
}

```

## Usage 

The macro is used via [@:autoBuild](https://haxe.org/manual/macro-auto-build.html)

```haxe
class Test {
  static function main() {
    // poised dagger damage types
    final dmg = new DamageSet([Poison, Piercing, Slashing]);
    trace(dmg.Acid); // false
    trace(dmg.Bludgeoning); // false
    trace(dmg.Cold); // false
    trace(dmg.Fire); // false
    trace(dmg.Force); // false
    trace(dmg.Lightning); // false
    trace(dmg.Necrotic); // false
    trace(dmg.Piercing); // true
    trace(dmg.Poison); // true
    trace(dmg.Psychic); // false
    trace(dmg.Radiant); // false
    trace(dmg.Slashing); // true
    trace(dmg.Thunder); // false
  }
}

class DamageSet extends EnumSet<DamageType> {}

enum DamageType {
  Acid;
  Bludgeoning;
  Cold;
  Fire;
  Force;
  Lightning;
  Necrotic;
  Piercing;
  Poison;
  Psychic;
  Radiant;
  Slashing;
  Thunder;
}

@:autoBuild(Macro.buildSet())
class EnumSet<E:EnumValue> {
  final list = new Array<E>();

  public function new(list:Array<E>) {
    for (item in list)
      add(item);
  }

  inline public function has(value:E):Bool {
    return list.contains(value);
  }

  public function add(value:E) {
    if (has(value) == false)
      list.push(value);
  }

  public function remove(value:E) {
    list.remove(value);
  }
}
```
Notice that a field for each `DamageType` were added to `DamageSet`

> Author: [George Kurelic](https://github.com/geokureli)
