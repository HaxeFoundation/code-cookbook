**Thanks for contributing to the Haxe Code Cookbook!**

### Formatting 

 * braces on same line
 * two-space indentation
 * no type-hints for local variables and function return unless it's instructive
 * type-hints for fields
 * type-hints for function arguments unless it's very obvious
 * judicious use of extra line-breaks to avoid ugly automatic breaks (check the output)
 
This would be a typical template to use. Use <code>```haxe</code> for syntax highlighting.  
The first heading is used in the menu. Keep this title short.
You can tag the snippet using the `[tags]: / "tag1,tag2"`. Don't use spaces, try to use [an existing tag](used-tags.txt).
 
```markdown
   [tags]: / "enum,pattern-matching,macro,macro-function"
   
   # Title of the page

   Description and explanation of the code.

   ## Implementation
   ```haxe
    class Test {
      // Code here
    }
    ```
   ## Usage
    ```haxe
    class Test {
      // Code here
    }
    ```
    > More on this topic: <http://haxe.org/manual/class-field.html>
    > Author: [Name](http://github.com/usename)
  
```

### Other remarks

 * Provide code comments where needed.
 * Please mention the author / sources in the bottom of the page.
 * If possible, link to related pages in the [Haxe Manual](http://haxe.org/manual) / [API documentation](http://api.haxe.org)
 * If you want to use images, upload them in the <assets/includes/img> folder.
