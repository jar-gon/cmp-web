# 获取input的val
window.getInputVal = (IDArray) ->
  p = {}
  $.each(IDArray, (i,e) ->
    n = $('#'+e).attr('name')
    v = $('#'+e).val()
    p[n] = v.trim()
  )
  p
