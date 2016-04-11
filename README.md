# Haxe Code Cookbook

[![Build Status](https://travis-ci.org/HaxeFoundation/code-cookbook.svg?branch=master)](https://travis-ci.org/HaxeFoundation/code-cookbook)

> Sources for the Haxe Code Cookbook site

This project contains a static website generator, it is mixing templates and markdown files into plain HTML files.

## Structure

 * The actual code snippets are in [assets/content/cookbook](assets/content/cookbook), organized per folder.
 * The template files are in [assets/content/](assets/content).
 * The static files (css, js, images) files are in [assets/includes/](assets/includes).
 * The Haxe source files of the generator are in [src/](src).
 * The website-generated content will output in `output`.

## Contributing snippets

Please add/edit the code snippets (markdown files) in the [assets folder](assets/content/cookbook) and do a pull request.

##### Formatting snippets

It would be nice if you keep the formatting of the code in the same style as used already:

 * braces on same line
 * two-space indentation
 * no type-hints for local variables and function return unless it's instructive
 * type-hints for fields
 * type-hints for function arguments unless it's very obvious
 * judicious use of extra line-breaks to avoid ugly automatic breaks (check the output)

##### Other remarks
 
 * the first heading is used in the navigation. Keep this title short.
 * tag the snippet using `[tags]: / "tag1,tag2"` (no spaces). Try to use [an existing tag](http://code.haxe.org/).
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

## Running a local copy

To run the project you need [Haxe](http://haxe.org).

Call `build-site.bat` to re-generate the output files.

## Contributing to the generator

You need [Haxe](http://haxe.org) 3.2+ installed.

The static site generator source depends on [hxtemplo](http://lib.haxe.org/p/hxtemplo) and [markdown](http://lib.haxe.org/p/markdown).
Install from haxelib:
```
haxelib install hxtemplo
haxelib install markdown
```
The CSS files are compressed using [less](http://lesscss.org/#using-less). 
Install from npm:
```
npm install -g less
npm install -g less-plugin-clean-css
```
