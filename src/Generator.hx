package;

import data.Category;
import data.Page;
import data.TemplateData;
import haxe.ds.StringMap;
import haxe.io.Path;
import markdown.AST.ElementNode;
import sys.FileSystem;
import sys.io.File;
import templo.Template;
import util.GitUtil.GitAuthorInfo;

using StringTools;

/**
 * @author Mark Knol
 */
class Generator {
  public var contentPath = "./assets/content/";
  public var outputPath = "./output/";
  public var repositoryUrl = "";
  public var repositoryBranch = "";
  public var basePath = "";
  public var titlePostFix = "";
  public var cookbookFolder = "cookbook/";
  public var assetsFolderName = "assets";
  
  private var _pages:Array<Page> = new Array<Page>();
  private var _folders:StringMap<Array<Page>> = new StringMap<Array<Page>>();
  private var _templates:StringMap<Template> = new StringMap<Template>();
  
  // match authors by name. not fully correct but works good enough to link github names with git names
  private var _authorByName:StringMap<GitAuthorInfo> = new StringMap<GitAuthorInfo>();
  
  public function new() { }
  
  /**
   * Build the Code Cookbook website with static website generator.
   * @param doMinify minifies the HTML output.
   */
  public function build (doMinify:Bool = false) {
    initTemplate();
    
    addCookbookPages(cookbookFolder);
    trace(_pages.length + " articles");
    
    var homePage = addGeneralPages();
    
    // create list of categories (after all other pages are added)
    var sitemap:Array<Category> = createSitemap();
    
    // sort categories on name for display
    sitemap.sort(function(a, b) return a.title > b.title ? 1 : -1);
    
    // put category "other" as last item
    var beginnerCategory = sitemap.filter(function(c) return c.title.toLowerCase() == "beginner")[0];
    sitemap.remove(beginnerCategory);
    sitemap.unshift(beginnerCategory);
    
    // put category "other" as last item
    var otherCategory = sitemap.filter(function(c) return c.title.toLowerCase() == "other")[0];
    sitemap.remove(otherCategory);
    sitemap.push(otherCategory);
    
    // add overview page for each category
    addCategoryPages(sitemap);
    
    // assign page.category
    for (page in _pages) page.category = getCategory(sitemap, page);
    
    // sort category pages by filename
    for (category in sitemap) category.pages.sort(function(a, b) {
      var a = a.outputPath.file;
      var b = b.outputPath.file;
      return if (a < b) -1;
        else if (a > b) 1;
        else 0;
    });
    
    
    // find serie pages
    var seriePages = [for (p in _pages) if (p != null && p.visible && p.isSerieHome()) p];
   
    for (page in seriePages) {
      // add dates to table-of-content (to be used on homepage)
      page.dates = page.category.pages[0].dates;
      
      // find+assign parent category
      var ids = page.category.folder.replace(cookbookFolder, "").split("/");
      var parentId = ids.shift();
      parentId = parentId.toLowerCase().replace(" ", "-");
      page.category.parent = getCategoryById(sitemap, parentId);
    }
    
    // Add serie pages as if they are normal pages in the category
    for (category in sitemap) {
      if (!category.isSerie) {
        for (page in seriePages) {
          if (page.category.id.indexOf(category.id) == 0) {
            category.pages.push(page);
          }
        }
      }
    }
    
    // assign prev/next pages (for series)
    for (page in _pages) {
      if (page.visible && page.category != null && page.category.isSerie) {
        var index = page.category.pages.indexOf(page);
        page.prev = page.category.pages[index - 1];
        if (page.prev != null && (!page.prev.visible || page.prev.isSerieHome())) page.prev = null;
        page.next = page.category.pages[index + 1];
        if (page.next != null && (!page.next.visible || page.next.isSerieHome())) page.next = null;
      }
    }
    
    var tags:StringMap<Array<Page>> = collectTags();
    // add tags to the home page (used for meta keywords)
    homePage.tags = [for (tag in tags.keys()) tag];
	trace(homePage.title);
    addTagPages(tags);

    // sort pages by date; get most recent pages
    var latestCreatedPages = [for (p in _pages) {
      if (p != null && p.category != null && p.visible && p.dates != null && p.dates.created != null && (!p.category.isSerie || p.isSerieHome())) p;
    }];
    latestCreatedPages.sort(function(a, b) {
      var a = a.dates.created.getTime(), b = b.dates.created.getTime();
      return if (a > b) -1 else if (a < b) 1 else 0;
    });
    
    
    for(page in _pages) {
      // set the data for the page
      var category = getCategory(sitemap, page);
      var data:TemplateData = {
        title: category != null ? '${page.title} - ${category.title} $titlePostFix' : '${page.title} $titlePostFix', 
        now: Date.now(),
        pages: _pages,
        currentPage: page,
        currentCategory: category,
        sitemap: sitemap,
        basePath: basePath,
        tags: tags,
        pageContent: null,
        DateTools: DateTools,
        convertDate:function(date:Date) {
          // American date format is retarded: "Wed, 02 Oct 2002 13:00:00 GMT"
          var month = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(",")[date.getMonth()];
          var dayName = "Sun,Mon,Tue,Wed,Thu,Fri,Sat".split(",")[date.getDay()];
          var day = Std.string(date.getDate()).lpad("0", 2);
          var time = Std.string(date.getHours()).lpad("0", 2) + ":" + Std.string(date.getMinutes()).lpad("0", 2)  + ":" + Std.string(date.getSeconds()).lpad("0", 2);
          return '$dayName, $day $month ${date.getFullYear()} $time GMT';
        },
        getSortedTags: getSortedTags.bind(tags),
        getTagTitle:getTagTitle,
        latestCreatedPages: function(amount) return [for (i in 0...min(amount, latestCreatedPages.length)) latestCreatedPages[i]],
        seriePages: function(amount) return [for (i in 0...min(amount, seriePages.length)) seriePages[i]],
      }
      if (page.contentPath != null) 
      {
        page.addLinkUrl = (category != null) ? getAddLinkUrl(category) : getAddLinkUrl(page);
        data.pageContent = page.pageContent != null ? page.pageContent : getContent(contentPath + page.contentPath, data);
      }
      
      // execute the template
      var templatePath = contentPath + page.templatePath;
      if (!_templates.exists(templatePath)) {
        _templates.set(templatePath, Template.fromFile(templatePath));
      }
      var template = _templates.get(templatePath);
      
      var html = util.Minifier.removeComments(template.execute(data));
      
      if (doMinify) {
        // strip crap
        var length = html.length;
        html = util.Minifier.minify(html);
        var newLength = html.length;
		
        //trace("optimized " + (Std.int(100 / length * (length - newLength) * 100) / 100) + "%");
      }
		html = html.replace("<blockquote></blockquote>",""); // remove empty blockquotes caused by removing authors
      
      // make output directory if needed
      var targetDirectory = Path.directory(outputPath + page.outputPath);
      if (!FileSystem.exists(targetDirectory)) {
        FileSystem.createDirectory(targetDirectory);
      }
      
      // write output to file
      File.saveContent(outputPath + page.outputPath, html);
    }
    
    var allTags = [for (tag in tags.keys()) tag];
    //File.saveContent("used-tags.txt", allTags.join("\r\n"));
    
    trace(sitemap.length + " categories");
    trace(allTags.length + " tags");
    trace(_pages.length + " pages done!");
  }

  private function addPage(page:Page, folder:String = null) {
    _pages.push(page);
    
    page.absoluteUrl = getAbsoluteUrl(page);
    page.baseHref = getBaseHref(page);
    
    if (page.contentPath != null) {
      page.dates = util.GitUtil.getStat(contentPath + page.contentPath);
      page.contributors = util.GitUtil.getAuthors(contentPath + page.contentPath, _authorByName);
      page.contributionUrl = getContributionUrl(page);
      page.editUrl = getEditUrl(page);
      page.commitHistoryUrl = getCommitHistoryUrl(page);
    }
    
    if (folder != null) {
      if (!_folders.exists(folder)) {
        _folders.set(folder, []);
      }
      _folders.get(folder).push(page);
    }
  }
  
  private function addCategoryPages(sitemap:Array<Category>) {
    for (category in sitemap) {
      category.isSerie = isSerie(category);
      var page = if (category.isSerie) 
                  new Page("layout-page-toc.mtt",  "table-of-content-serie.mtt", 'category/${category.id}/index.html')
                 else 
                  new Page("layout-page-toc.mtt",  "table-of-content-category.mtt", 'category/${category.id}/index.html')
                    .setTitle('Haxe ${category.title} articles overview')
                    .setDescription('Overview of Haxe ${category.title.toLowerCase()} snippets and tutorials.')
                    .hidden();
     
      if (category.isSerie) {
        category.content = parseMarkdownContent(page, category.folder + "index.md");
      } 
      addPage(page, category.folder);
    }
  }
  
  static inline function isSerie(category:Category) {
    return category.pages[0].level == 2;
  }
  
  private function addTagPages(tags:StringMap<Array<Page>>) {
    for (tag in tags.keys()) {
      var tagTitle = getTagTitle(tag);
      addPage(new Page("layout-page-toc.mtt",  "tags.mtt", 'tag/$tag.html')
                        .setTitle('Haxe $tagTitle articles overview')
                        .setCustomData({tag:tag, pages: tags.get(tag)})
                        .setDescription('Overview of Haxe code snippets, examples and tutorials tagged with $tagTitle.')
                        .hidden(), "tags");
    }
  }
  
  private function addGeneralPages():Page {
    var homePage = new Page("layout-page-main.mtt", "index.mtt", "index.html")
                          .hidden()
                          .setTitle("Learn with Haxe - Community driven Haxe code snippets, examples and tutorials.")
                          .setDescription('The Haxe Code Cookbook is a central learning resource with Haxe code snippets, examples and tutorials.');
    
    var errorPage = new Page("layout-page-main.mtt", "404.mtt", "404.html")
                          .hidden()
                          .setTitle("Page not found");
    
    var sitemapPage = new Page("sitemap.mtt", null, "sitemap.xml")
                          .hidden()
                          .setTitle("Sitemap");
    
    var rssPage = new Page("rss.mtt", null, "rss.xml")
                          .hidden()
                          .setTitle("RSS");
    
    addPage(rssPage, "/rss");
    addPage(homePage, "/home");
    addPage(errorPage, "/404");
    addPage(sitemapPage, "/sitemap");
    
    errorPage.baseHref = "/";
    
    return homePage;
  }
  
  private function addCookbookPages(documentationPath:String, level:Int = 0) {
    for (file in FileSystem.readDirectory(contentPath + documentationPath)) {
      var outputPathReplace = 'category/';
      if (file == "index.md") continue; // skip this index page, its used for landingspages of series
      if (!FileSystem.isDirectory(contentPath + documentationPath + file)) {
        var pageOutputPath = documentationPath.replace(cookbookFolder, outputPathReplace);
        pageOutputPath = pageOutputPath.toLowerCase().replace(" ", "-") + getWithoutExtension(file).toLowerCase() + ".html";
        var page = new Page("layout-page-snippet.mtt",  documentationPath + file, pageOutputPath);
        page.level = level;
        addPage(page, documentationPath);
        page.pageContent = parseMarkdownContent(page, documentationPath + file);
      } else {
        if (file == assetsFolderName) {
          // when assets folder name is found, dont recurse but include directory in output
          includeDirectory(contentPath + documentationPath + file, outputPath + file);
        } else {
          // recursive
          addCookbookPages(documentationPath + file + "/", level+1);
        }
      }
    }
  }

  private function getSortedTags(a:StringMap<Array<Page>>) {
    var keys = [for(key in a.keys()) {tag:key, total:a.get(key).length}];
    keys.sort(function(a, b) return a.total == b.total ? 0 :(a.total > b.total ? -1 : 1));
    return [for (key in keys) key.tag];
  }

  private function getTagTitle(tag:String):String {
    return tag.replace("-", " ");
  }

  // categorizes the folders 
  private function createSitemap():Array<Category> {
    var sitemap = [];
    for (key in _folders.keys()) {
      var structure = key.split("/");
      structure.pop();
      if (key.indexOf(cookbookFolder) == 0) {
        var isSerie = _folders.get(key)[0].level == 2;
        var id = structure.pop();
        var categoryId = isSerie ? structure.pop() + "/" + id : id;
        categoryId = categoryId.toLowerCase().replace(" ", "-");
        var category = new Category(categoryId, id.replace("-", " "), key, _folders.get(key));
        category.absoluteUrl = basePath + category.outputPath;
        sitemap.push(category);
      }
    }
    return sitemap;
  }
  
  // collects all tags and counts them
  private function collectTags() {
    var tags = new StringMap<Array<Page>>();
    for (page in _pages) {
      if (page.tags != null) {
        for (tag in page.tags) {
          tag = tag.toLowerCase();
          if (!tags.exists(tag)) {
            tags.set(tag, []);
          }
          tags.get(tag).push(page);
        }
      }
    }
    return tags;
  }
  
  private function replaceTryHaxeTags(content:String) {
    //[tryhaxe](http://try.haxe.org/embed/ae6ef)
    return  ~/(\[tryhaxe\])(\()(.+?)(\))/g.replace(content, '<iframe src="$3" class="try-haxe"><a href="$3">Try Haxe!</a></iframe>');
  }
  
  private function replaceYoutubeTags(content:String) {
    //[youtube](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
    return  ~/(\[youtube\])(\()(.+?)(\))/g.replace(content, '<div class="flex-video widescreen"><iframe src="$3" frameborder="0" allowfullscreen=""></iframe></div>');
  }
  
  private function replaceHaxeOrgLinks(content:String) 
  {
    return content
      .replace("http://haxe.org", "https://haxe.org")
      .replace("http://try.haxe.org", "https://try.haxe.org");
  }
  
  private function replaceAuthor(page:Page, content:String) {
    //Author: [name](url) / [name](url) 
    if (content.indexOf("Author:") != -1) {
      var authorLineOld = content.split("Author:").pop().split("\n").shift();
	  
	  var authorLine:String = authorLineOld;
	  var ereg:EReg = ~/\[(.*?)\]\((.+?)\)/g;
	  var authors:Array<GitAuthorInfo> = [];
	  while (ereg.match(authorLine)) {
			var name = ereg.matched(1);
			
			var author:GitAuthorInfo = _authorByName.exists(name) ? _authorByName.get(name) : { name: name };
			author.profileLink = ereg.matched(2);
			author.username = ereg.matched(2).split("/").pop();
			authors.push(author);
			_authorByName.set(name, author);
			authorLine = ereg.matchedRight();
		}
	  
	  // remove author from contributors (that otherwise looks like duplicates)
	  for (author in authors) 
	  {
		  for (contributor in page.contributors.copy()) 
		  {
			  if (contributor.name == author.name) page.contributors.remove(contributor);
		  }
	  }
	  page.authors = authors;
	  
      return ~/(Author:.+?(\n|\r|$))/g.replace(content, ""); 
    } else {
      return content;
    }
  }
  
  private function getCategory(sitemap:Array<Category>, page:Page):Category {
    for (category in sitemap) {
      if (category.pages.indexOf(page) != -1 ) {
        return category;
      }
    }
    return null;
  }
  
  private function getCategoryById(sitemap:Array<Category>, id:String):Category {
    for (category in sitemap) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }
  
  private function getBaseHref(page:Page) {
    if (page.outputPath.file == "404.html") {
      return basePath;
    }
    var href = [for (s in page.outputPath.toString().split("/")) ".."];
    href[0] = ".";
    return href.join("/");
  }
  
  public inline function getCommitHistoryUrl(page:Page) {
    return '${repositoryUrl}commits/${repositoryBranch}/${contentPath}${page.contentPath}';
  }
  
  public inline function getEditUrl(page:Page) {
    return '${repositoryUrl}edit/${repositoryBranch}/${contentPath}${page.contentPath}';
  }
  
  public inline function getContributionUrl(page:Page) {
    return '${repositoryUrl}tree/${repositoryBranch}/${contentPath}${page.contentPath}';
  }
  
  public function getAddLinkUrl(category:Category = null, page:Page = null) {
    var fileNameHint = "/snippet-name.md/?filename=snippet-name.md";
    var directory = if (category != null) {
      category.pages[0].contentPath.dir;
    } else {
      page.contentPath.dir;
    }
    return '${repositoryUrl}new/master/${contentPath}${directory}${fileNameHint}';
  }
  
  public inline function getAbsoluteUrl(page:Page) {
    return Path.normalize(basePath + page.outputPath.toString());
  }
  
  private static inline function getWithoutExtension(file:String) {
    return Path.withoutDirectory(Path.withoutExtension(file));
  }
  
  private function getContent(file:String, data:Dynamic) {
    return switch(Path.extension(file)) {
      case "md": 
        parseMarkdownContent(null, file);
      case "mtt": 
        Template.fromFile(file).execute(data);
      default: 
        File.getContent(file);
    }
  }
  
  public function parseMarkdownContent(page:Page, file:String):String {
    var document = new Markdown.Document();
    var markdown = File.getContent(contentPath + file);
    markdown = replaceHaxeOrgLinks(markdown);
    markdown = replaceYoutubeTags(markdown);
    markdown = replaceTryHaxeTags(markdown);
    markdown = replaceAuthor(page, markdown);
    
    try {
      // replace windows line endings with unix, and split
      var lines = ~/(\r\n|\r)/g.replace(markdown, '\n').split("\n");
      
      // parse ref links
      document.parseRefLinks(lines);
      
      // parse tags
      if (page != null) {
        var link = document.refLinks["tags"];
        page.tags = link != null ? [for (a in link.title.split(",")) a.toLowerCase().trim()] : null;
      }
      
      // parse ast      
      var blocks = document.parseLines(lines);
      // pick first header, use it as title for the page
      var titleBlock = null;
      if (page != null) {
        var hasTitle = false;
        for (block in blocks) {
          var el = Std.instance(block, ElementNode);
          if (el != null) {
            if (!hasTitle && el.tag == "h1" && !el.isEmpty()) {
              page.title = new markdown.HtmlRenderer().render(el.children);
              hasTitle = true;
              titleBlock = block;
              continue;
            }
            if (hasTitle && el.tag != "pre" && page.description == null) {
              var description = new markdown.HtmlRenderer().render(el.children);
              page.description = new EReg("<(.*?)>", "g").replace(description, "").replace('"', "").replace('\n', " ");
              break;
            }
          }
        }
      }
      if (titleBlock != null) blocks.remove(titleBlock);

      return Markdown.renderHtml(blocks);
    } catch (e:Dynamic){
      return '<pre>$e</pre>';
    }
  }
  
  public function includeDirectory(dir:String, ?path:String) {
    if (path == null) path = outputPath;
    else FileSystem.createDirectory(path);
    trace("include directory: " + path);
    
    for (file in FileSystem.readDirectory(dir)) {
      var srcPath = '$dir/$file';
      var dstPath = '$path/$file';
      if (FileSystem.isDirectory(srcPath)) {
        FileSystem.createDirectory(dstPath);
        includeDirectory(srcPath, dstPath);
      } else {
        File.copy(srcPath, dstPath);
      }
    }
  }
  
  private function initTemplate() {
    // for some reason this is needed, otherwise templates doesn't work.
    // the function fails, but i think internally Template can resolve paths now.
    try { 
      Template.fromFile(contentPath + "layout.mtt").execute({});
    } catch (e:Dynamic) { }
  }
  
  static inline private function min(a:Int, b:Int) return Std.int(Math.min(a, b));
}
