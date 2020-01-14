(function(onload) { // load
  if (window.addEventListener) {
      window.addEventListener('load', onload, false);
  } else if (window.attachEvent) {
      window.attachEvent('onload',  onload, false);
  } else {
      window.onload = onload;
  }
})(function() {
  if (typeof prettyPrint === 'function') {
    var pre = document.getElementsByTagName('pre');
    for (var n = pre.length; n --> 0;) {
      if (/^(?:code|samp)$/.test(pre[n].firstChild.nodeName.toLowerCase())) {
        pre[n].className = (pre[n].className || '').split(/[ \t\r\n]+/).concat('prettyprint').join(' ')
      }
    }
    prettyPrint();
  }
});
