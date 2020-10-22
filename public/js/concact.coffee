# 联系我们
$btn = $ '#btn'
$alert = $ '#alert'

# submit
$btn.click ->
  p = window.getInputVal(['username', 'companyname', 'mobile', 'demand'])
  url = 'http://8.210.177.21:5000/api/v1/try'
  if p.client_name is '' or p.company_name is '' or p.mobile is '' or p.demand is ''
    $('.yq-form-error').html('请填写完整信息')
    return

  if not /^1[^1269]\d{9}$/.test(p.mobile)
    $('.yq-form-error').html('请输入正确的电话号码')
    return

  $btn.attr('disabled', true)
  $('.yq-form-error').html('')

  $.ajax({
    type: "post"
    url: url
    contentType: "application/x-www-form-urlencoded"
    data: p
    dateType: "json"
    complete: () ->
      $btn.attr('disabled', false)
    success: (res) ->
      $alert.show()
      setTimeout(() ->
        $alert.hide()
      , 3000)
    error: (err) ->
      $('.yq-form-error').html(err.responseJSON.retMsg)
  })

  ###
  handleData = (result) ->
    console.info(result)
  $.ajax({
    type:"post",
    url: "http://cross-domain/get_data",
    dataType: "jsonp",
    data: "p",
    jsonp: "callback",
    jsonpCallback: "handleData"
  })
  ###
