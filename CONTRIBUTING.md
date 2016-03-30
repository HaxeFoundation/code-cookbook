**Thanks for contributing to the Haxe Code Cookbook!**

### Formatting 

 * braces on same line
 * two-space indentation
 * no type-hints for local variables and function return unless it's instructive
 * type-hints for fields
 * type-hints for function arguments unless it's very obvious
 * judicious use of extra line-breaks to avoid ugly automatic breaks (check the output)

### Other remarks
 
 * the first heading is used in the navigation. Keep this title short.
 * tag the snippet using `[tags]: / "tag1,tag2"` (no spaces). Try to use [an existing tag](used-tags.txt).
 * mention the author / sources at the bottom of the page.
 * if possible, link to related pages in the [Haxe Manual](http://haxe.org/manual) / [API documentation](http://api.haxe.org)
 * if you want to use images, upload them in the <assets/includes/img> folder.

This would be a typical template to use. Use <code>```haxe</code> for syntax highlighting:
 
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
