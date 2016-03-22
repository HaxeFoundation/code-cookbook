(function() {
  highlightNavLinks();
  
  window.onhashchange = highlightNavLinks;
  function highlightNavLinks() {
    var activeCssClass = "active";
    var links = document.getElementsByTagName("a");
    for(var i=0, leni=links.length; i<leni; i++) {
      var link = links[i];
      if (link.href == window.location) {
        addClass(link, activeCssClass);
        if (link.parentNode.tagName.toLowerCase() == 'li') {
          addClass(link.parentNode, activeCssClass);
        }
      } else {
        removeClass(link.parentNode, activeCssClass);
        if (link.parentNode.tagName.toLowerCase() == 'li') {
          removeClass(link.parentNode, activeCssClass);
        }
      }
    }
  }
  
  function removeClass(el, cssClass) { el.className = el.className.split(cssClass).join(""); }
  function addClass(el, cssClass) { el.className += " " + cssClass; }
})();