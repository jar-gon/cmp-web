# 返回顶部
backTop = $ '#backTop'
root = $ 'html, body'
$(window).scroll ->
    if $(this).scrollTop() > 200
      backTop.stop().fadeIn(300)
    else
      backTop.stop().fadeOut(300)
backTop.click ->
    $('html,body').animate({scrollTop:0},'slow')

$('a').click ->
  root.animate({
    scrollTop: $( $.attr(this, 'href') ).offset().top
  }, 'slow')
  return false

_hmt = _hmt || [];
(() ->
  hm = document.createElement("script")
  hm.src = "https://hm.baidu.com/hm.js?f5b7d1b79a43e38263dc652cb1b0b9cd"
  s = document.getElementsByTagName("script")[0]
  s.parentNode.insertBefore(hm, s)
)()
