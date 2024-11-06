[tags]: / "expression-macro,building-fields"

# Add enum values as fields

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
    final enumCT = Context.getType(enumType.module + "." + enumType.name).toComplexType();

    for (name => field in enumType.constructs) {
      // Determine the full path of the enum field
      final path = enumType.module.split(".");
      path.push(enumType.name);
      path.push(field.name);

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
		final grades = new GradeSet();
		grades.add(A);
		grades.add(F);
		grades.add(C);
		trace(grades.A); // true
		trace(grades.B); // false
		trace(grades.C); // true
		trace(grades.D); // false
		trace(grades.F); // true
	}
}

class GradeSet extends EnumSet<Grade> {}

enum Grade { A; B; C; D; F; }

@:autoBuild(Macro.buildSet())
class EnumSet<E:EnumValue> {
	final list = new Array<E>();

	public function new() {}

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
Notice that fields A, B, C, D, E and F were added to GradeSet

> Author: [George Kurelic](https://github.com/geokureli)
