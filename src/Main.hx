package;

/**
 * @author Mark Knol
 */
class Main {
  public static function main() {
    haxe.Timer.measure(function() {
      var generator = new Generator();

      generator.build();
      generator.includeDirectory("assets/includes");

      Redirections.generate();
    });
  }
}
