# Haxe Code Cookbook

[![Build Status](https://travis-ci.org/HaxeFoundation/code-cookbook.svg?branch=master)](https://travis-ci.org/HaxeFoundation/code-cookbook)

> Sources for the [Haxe Code Cookbook](http://code.haxe.org) site, a community driven resource website for learning Haxe in practise.

The repository contains a static website generator, which converts markdown articles into a website. The project is being developed here on GitHub, feel free to contribute Haxe related code snippets and tutorials.

## Structure

 * The actual articles are in [assets/content/cookbook](assets/content/cookbook), organized per folder.
 * The html template files are in [assets/content/](assets/content).
 * The static files (css, js, images) files are in [assets/includes/](assets/includes).
 * The Haxe source files of the generator are in [src/](src).
 * The website-generated content will output in `output/` (excluded from git).

## Contributing 

## Contributing changes

To contribute a change, you have to make a pull request. This can be done using the GitHub website or by fork/cloning the project.

##### Contributing using GitHub as online editor 

This is the easiest way of doing small changes:

- Navigate to an article on <https://code.haxe.org> and press the edit button on any page: ![image](https://user-images.githubusercontent.com/576184/78226927-c544eb00-74cc-11ea-8d59-8658b017126f.png)
- You are redirected to GitHub. Once you have an account and are logged in, you can make the change in the online editor.
- Set the description / what you changed and press the _Request change_ button:
![image](https://user-images.githubusercontent.com/576184/78226584-3506a600-74cc-11ea-878f-4070ca04107d.png)
- A pull request will be created. GitHub makes a fork for you automatically.

##### Contributing using a fork

This would also allow to test/see the changes before submitting which is also useful when you want to add new pages.

- Make a fork (on GitHub) of the project.
- Checkout your repo on your machine, create a new branch for the pull request.
- Make the changes in that new branch.
- Push the commits (they go to your fork).
- On GitHub, you make a pull request from your fork's branch to the original repo.

## Creating articles

Please add/edit the articles (markdown files) in the [assets folder](assets/content/cookbook) and do a pull request. The scope of the cookbook includes the core language, the standard library, and also any libraries maintained by the Haxe Foundation.

#### Formatting 

It would be nice if you keep the formatting of the code in the same style as used already:

 * Braces on same line.
 * Two-space indentation.
 * No type-hints for local variables and function return unless it's instructive.
 * Type-hints for fields.
 * Type-hints for function arguments unless it's very obvious.
 * Judicious use of extra line-breaks to avoid ugly automatic breaks (check the output).
 
#### Other remarks
 
 * The first heading is used in the navigation. Keep this title short.
 * The first paragraph is used as description. Describe what the content of the article is about.
 * Use `> Author: [Name](https://github.com/username)` to mark yourself as author of the article. The other contributors are inferred from git commits.
 * Tag the article using `[tags]: / "tag1,tag2"` (no spaces). Try to use [an existing tag](http://code.haxe.org/).
 * Mention the author / sources at the bottom of the page.
 * If you want to include a [try.haxe.org](https://try.haxe.org) code snippet use `[tryhaxe](https://try.haxe.org/embed/76f24)`.
 * If you want to include a YouTube video use `[youtube](https://www.youtube.com/watch?v=dQw4w9WgXcQ)`.
 * If possible, link to related pages in the [Haxe Manual](https://haxe.org/manual) / [API documentation](https://api.haxe.org).
 * If you want to use images or other includes, create a folder called _assets_ in the same directory as the article and link to that.

This would be a typical template to use. Use <code>```haxe</code> for syntax highlighting:
 
<pre>
&lbrack;tags&rbrack;: / "class,array,json,building-fields"

# Title of the page

Description and explanation of the code.

## Implementation
&grave;&grave;&grave;haxe
class Main {
  // Code here
}
&grave;&grave;&grave;

## Usage

Description of how to use/test the code.

&grave;&grave;&grave;haxe
class Test {
  // Code here
}
&grave;&grave;&grave;

&gt; More on this topic: 
&gt; 
&gt; * &lbrack;Class field in Haxe Manual&rbrack;(https://haxe.org/manual/class-field.html)
&gt; 
&gt; Author: &lbrack;Name&rbrack;(https://github.com/username)
</pre>

## Running a local copy

To run the project you can use Neko:

Call `neko CodeCookBook.n` to re-generate the output files.

## Contributing to the generator

You need [Haxe 3.4.2+](https://haxe.org/download/list/) installed.

The static site generator source depends on [hxtemplo](https://lib.haxe.org/p/hxtemplo) and [haxe-markdown](https://lib.haxe.org/p/markdown).

Install the libraries using haxelib, run the following command in the root of the project:
```
haxelib install all
```
The CSS files are compressed using [less](http://lesscss.org/#using-less). 
Install from npm:
```
npm install -g less
npm install -g less-plugin-clean-css
```
