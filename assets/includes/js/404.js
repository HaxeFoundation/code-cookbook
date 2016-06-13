/**
 * @author Mark Knol
 */
(function() {
  var pages = window.pages;
  var searchResults = [];
  var path = window.location.href.split("/").pop().split(".").shift();
  console.log(path);
  for(var i=0;i<pages.length;i++) {
    var page = pages[i];
    if(page.url.indexOf(path) != -1 && page.url != "404.html") { 
      searchResults.push(page)
    };
  }
  var html = "";
  if(searchResults.length==0) {
    // nothing found, redirect to home
    window.location.href = "//code.haxe.org/"; 
  } else if(searchResults.length ==1 ){
    // one thing found, redirect to it
    window.location.href = searchResults[0].url;
  } else {
    // list options
    html += "<br/><br/><br/><h2>Page not found</h2><p>Did you mean:</p>"
    html += "<ul>"
    for(var i=0;i<searchResults.length;i++) {
      html+= "<li><a href='"+searchResults[i].url+"'>"+searchResults[i].title+"</a></li>";
    }
    html += "</ul>"
    document.getElementById("result404").innerHTML = html;
  }
})();