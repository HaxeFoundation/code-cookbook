[tags]: / "javascript,dom,html"

# Adding a HTML element to the DOM

This is an example to add a paragraph element to the HTML page when the DOM is ready. This tutorial contains two methodes; with and without jQuery.

> Haxe can compile to many targets, this example is specific for the Haxe/JavaScript target only.

## Structure of this example

Create a folder named **example** and create folders **bin** and **src**.

See example below:

```
+ example/
  + bin/
  + src/
    - Main.hx
  - build.hxml
```

### Appending a paragraph to DOM without jQuery

This is the **Main.hx** that needs to be saved in the **src** folder.

```haxe
import js.Browser.document;

class Main {
  // static entrypoint
  static function main() new Main();

  // constructor
  function new() {
    trace("DOM example");

    document.addEventListener("DOMContentLoaded", function(event) {
      trace("DOM ready");

      // Shorthand for document.creaetElement("p");
      var p = document.createParagraphElement(); 
      p.innerText = 'DOM ready';

      document.querySelector(".container").appendChild(p);
    });
  }
}
```

> `DOMContentLoaded` is supported in IE8+ <http://caniuse.com/#search=DOMContentLoaded>.

### Appending a paragraph to DOM with jQuery

This example is does pretty much same as the one above, but uses jQuery.

Remember that jQuery in Haxe is simply an [extern](https://haxe.org/manual/lf-externs.html) (type definition). You need to add a script-tag that links to jQuery in the HTML file. 

```haxe
import js.jquery.JQuery;

class Main {
  // static entrypoint
  static function main() new Main();

  // constructor
  function new() {
    trace("DOM example");

    new JQuery(function() {
      trace("DOM ready");
      new JQuery(".container").html("<p>DOM ready</p>");
    });
  }
}
```

## Compile

Compile the example with `haxe -cp src -main Main -js bin/example.js -dce full`.

There are a lot of different arguments that you are able to pass to the Haxe compiler.
These arguments can be placed in a text file which has the file-extension _.hxml_. 

**build.hxml**
```hxml
-cp src
-main Main
-js bin/example.js
-dce full
```

To run the build script, it can be passed to the Haxe compiler on the commandline: `haxe build.hxml`. 

Windows users can double click the hxml file to run it.

## index.html

As final step, to run the example you need to create **index.html** in the **bin** folder. Note that it has to have a `<div class="container"></div>`, because we're accessing this element in our code.
You can download jQuery from <https://jquery.com/> or use CDN as illustrated in the example. Of course when you are not using jQuery you can leave out this script-tag.

```html
<!DOCTYPE html>
<html>
<head>
  <title>Haxe/JavaScript - DOM example</title>
</head>
<body>
  <!-- container div needed for example code -->
  <div class="container"></div>

  <!-- from jQuery's CDN (http://jquery.com/download/#using-jquery-with-a-cdn) -->
  <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>

  <!-- Your Haxe compiled script -->
  <script src="example.js"></script>
</body>
</html>
```

## Running the example

Open the index.html in your favorite browser. It should display the text "DOM ready". Using the browser devtools (F12) you can inspect the DOM which shows the text is created inside a paragraph `<p>` element.

