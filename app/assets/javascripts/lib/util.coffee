window.App = window.App || {}
_ = window._

# 工具类,依赖jquery,lodash-core
App.util = {
  FORM_ELEMENTS: "input, textarea, select, button"

  ##### 取得上下文（jquery对象)，如果已经提供context，则将其包装成jquery对象，否则上下文设置为$(document.body)
  getContext: ($context)->
    return if $context then $($context) else $(document.body)

  ##### 隐藏 $selector, 并将其里面的表单元素禁用
  hideAndDisable: ($selector)->
    $selector.hide().find(App.util.FORM_ELEMENTS).prop('disabled', true)
    $selector.filter(App.util.FORM_ELEMENTS).prop('disabled', true)

  ##### 显示 $selector, 并将其里面的表单元素启用
  showAndEnable: ($selector)->
    $selector.show().find(App.util.FORM_ELEMENTS).prop('disabled', false)
    $selector.filter(App.util.FORM_ELEMENTS).prop('disabled', false)

  ##### 访问链接
  visit: (url) ->
    if window.Turbolinks and Turbolinks.supported
      Turbolinks.visit url
    else
      location.href = url

  ##### html 转义
  htmlDecode:(str)->
    s = ""
    return "" if str.length is 0
    s = str.replace(/&amp;/g, "&")
    s = s.replace(/&lt;/g, "<")
    s = s.replace(/&gt;/g, ">")
    s = s.replace(/&nbsp;/g, " ")
    s = s.replace(/&#39;/g, "\'")
    s = s.replace(/&quot;/g, "\"")
    s = s.replace(/<br>/g, "\n")

  htmlEncode: (str)->
    s = ""
    return "" if str.length is 0
    s = str.replace(/&/g, "&amp;")
    s = s.replace(/</g, "&lt;")
    s = s.replace(/>/g, "&gt;")
    s = s.replace(/\'/g, "&#39;")
    s = s.replace(/\ /g, "&nbsp;")
    s = s.replace(/\"/g, "&quot;")
    s = s.replace(/\n/g, "<br>")

  ##### 生成hash code
  hashCode: (str)->
    hash = 0
    return hash if !str or str.length is 0
    for i in [0..str.length-1]
      chr   = str.charCodeAt(i)
      hash  = ((hash << 5) - hash) + chr
      hash |= 0
    hash

  ##### 输入小数
  inputFloat:($e)->
    thisVal = $e.val()
    valAry = thisVal.split('.')
    pointLength = valAry.length - 1
    reg2 = /\.{2}/g
    reg3 = /[^\d.]/g
    # 如果连续两个小数点
    if reg2.test(thisVal)
      console.log 'sss'
      $e.val thisVal.replace(reg2,'.')

    #　如果输入两个小数点
    if pointLength >= 2
      $e.val thisVal.substring(0,thisVal.lastIndexOf('.'))

    # 如果先输入小数点
    if thisVal.indexOf('.') == 0
      $e.val '0'+'.'

    # 如果小数点后超出两位
    if pointLength >= 1
      if valAry[1].length >= 2
        $e.val valAry[0] + '.' + valAry[1].substring(0,2)

    #$e.val thisVal


    # 如果输入非数字
    if reg3.test(thisVal)
      str = thisVal.replace(/[^\d.]/g,"");
      $e.val str

  ##### 基于bootstrap弹出层, modal必须有一个唯一id
  showModal: (modalHtml, shownCallback) ->
    $newModal = $(modalHtml)
    unless $newModal.attr('id')
      console.error("弹出层必须制定id!")
      return null

    $oldModal = $("##{$newModal.attr('id')}")
    $modal = $oldModal
    if $oldModal.length > 0
      $oldModal.html($newModal.html()).modal('show').modal('handleUpdate')
    else
      $(document.body).append $newModal
      $newModal.modal('show')
      $modal = $newModal
    shownCallback($modal) if typeof shownCallback is 'function'
    return $modal

  ##### 基于bootstrap datetimepicker的时间控件初始化
  setupDatetimePicker: ($context) ->
    $context = @getContext($context)

    commonOptions = {
      locale: 'zh-cn'
    }

    datePickeroptions = {
      format: "YYYY-MM-DD"
    }

    datetimePickerOptions = {
      format: "YYYY-MM-DD HH:MM"
    }

    $('.date-picker', $context).each ->
      $this = $(this)
      $this.datetimepicker($.extend({}, commonOptions, datePickeroptions, $this.data()))
    $('.datetime-picker', $context).each ->
      $this = $(this)
      $this.datetimepicker($.extend({}, commonOptions, datetimePickerOptions, $this.data()))

  setupChosen: ($context) ->
    $context = @getContext($context)
    $('.chosen-select', $context).each ->
      $this = $ this
      $this.chosen({
        placeholder_text_single: '其选择'
        placeholder_text_multiple: '其选择'
        allow_single_deselect: true
        no_results_text: '没有匹配结果'
        width: '100%'
      })
      $chosenContainer = $this.siblings '.chosen-container'
      $this.siblings('.chosen-container').insertBefore $this

#  setInterval: (fn, delay=100, flag)->
#    if App.Flags && !App.Flags[flag] && window.console
#      console.warn("注意,你已经关闭 App.Flags.#{flag} 标记,相应的定时器将不会工作,如需关闭标记,请输入 App.Flags.#{flag}=true 或刷新页面.")
#
#    fn() # 第一次调用
#    # 开启定时器
#    return window.setInterval(->
#      unless App.Flags && !App.Flags[flag]
#        fn()
#    , delay)

  ##### 图片预览, 根据指定url全屏弹出图片.
  previewImage: (url) ->
    return unless url
    # get or create preview container
    $previewContainer = $('.preview-container')
    if $previewContainer.length is 0
      $previewContainer = $('<div class="preview-container"><div class="preview-layer"></div><div class="image-container"></div></div>')
      $(document.body).append($previewContainer)
      $previewContainer.on('click', '.preview-layer', -> $previewContainer.removeClass('shown'))
    $previewContainer.addClass('shown loading').removeClass('loaded-error')

    # load image
    img = new Image()
    img.onload = ->
      mt = 0 # margin-top
      ml = 0 # margin-left
      cssW = 0
      cssH = 0
      cw = $previewContainer.width() - 30
      ch = $previewContainer.height() - 30
      cw = 0 if cw < 0 
      ch = 0 if ch < 0
      w = img.width
      h = img.height
      
      # 容器尺寸较大
      if cw > w and ch > h
        cssW = w
        cssH = h
      else
        if cw > w
          cssW = ch/h * w
          cssH = ch
        else
          cssW = cw
          cssH = cw/w * h

      mt = cssH/2
      ml = cssW/2
      $previewContainer.removeClass('loading').find('.image-container').empty()
      .css({
        width: cssW,
        height: cssH,
        'margin-top': -mt,
        'margin-left': -ml
      })
      .append img
    img.onerror = ->
      $previewContainer.removeClass('loading').addClass('loaded-error')
    img.src = url

  ##### 依赖underscore && jquery, 居中弹出消息
  popMessage: (content, opts)->
    template = _.template("""
      <div class='pop-message'>
        <div class="alert-message message-<%=type%>">
          <i class="close fa fa-times"></i>
          <div class="message-body">
            <i class="icon <%=icon%>"></i>
            <%=content%>
          </div>
        </div>
        <div class="message-layer"></div>
      </div>
    """)

    # init options
    options = $.extend({}, {
      content: content,
      type: 'success', # success, info, warning, danger,
      icon: 'fa fa-check',
      duration: 5000, #自动消失等待时间
      hide: null,     #callback, 弹出层消失后调用
      cancelText: '取消',
      okText: '确认'
    }, opts)

    unless opts && opts.icon
      options.icon = switch options.type
        when 'success'  then 'fa fa-check-circle'
        when 'info'     then 'fa fa-info-circle'
        when 'warning'  then 'fa fa-exclamation-circle'
        when 'danger'   then 'fa fa-times-circle'
        else 'fa fa-info-circle'
    options.duration = 1000 if options.duration < 1000

    # build view  
    $msgContainer = $(template(options))
    $popMsg = $msgContainer.find('.alert-message')
    # remove exist pop message
    $('.pop-message').trigger('remove.popmessage')
    $('body').append($msgContainer)

    # set position
    $popMsg.addClass('pre-visible')
    $popMsg.css({
      'left': '50%',
      'top': '50%',
      'margin-left': -$popMsg.outerWidth()/2,
      'margin-top': -$popMsg.outerHeight()/2
    })
    $popMsg.removeClass('pre-visible')
      
    # events handlers  
    $msgContainer.on('click.popmessage', '.message-layer', ->
      $msgContainer.trigger('close.popmessage')
    ).on('close.popmessage', ->
      $popMsg.fadeOut(300, ->
        options.hide() if typeof options.hide is 'function'
        $msgContainer.off '.popmessage'
        $msgContainer.remove()
      )
    ).on('remove.popmessage', ->
      $msgContainer.off '.popmessage'
      $msgContainer.remove()
    )

    # show
    $popMsg.fadeIn(300)

    # auto close
    setTimeout(->
      $msgContainer.trigger('close.popmessage')
    , options.duration)
  
  ##### 依赖script js,
  loadScript: (script, scriptObjName, ready) ->
    if window[scriptObjName]
      ready() if typeof ready is 'function'
    else
      $script script, ->
        ready() if typeof ready is 'function'

  # 加载高德地图
  loadAMap: (ready) ->
    App.util.loadScript 'http://webapi.amap.com/maps?v=1.3&key=587b267d6434c7244728673a47bc06d3', 'AMap', ready
  # 加载echarts
  loadECharts: (ready) ->
    App.util.loadScript '/vendor/echarts.min.js', 'echarts', ready

  ##### 创建缓存版ajax
  createCacheableAjax: ->
    cache = {}
    PENDDING_FLAG = "__cache_pendding__"

    return (ajaxProperties, done = $.noop, fail = $.noop, beforeSend = $.noop)->
      key = JSON.stringify(ajaxProperties)
      success = ajaxProperties.success || $.noop
      error = ajaxProperties.error || $.noop
      delete ajaxProperties.success
      delete ajaxProperties.error

      if cache[key] and cache[key] isnt PENDDING_FLAG
        done(cache[key])
        success(cache[key])
      else
        cache[key] = PENDDING_FLAG
        beforeSend()
        $.ajax.call($, ajaxProperties)
        .done((data)->
          cache[key] = data
          done(data)
          success(data)
        ).fail((jxhr) ->
          cache[key] = null
          if typeof fail is 'function'
            fail(jxhr)
          error(jxhr)
        )

  ##### 获取form的validator(jquery validatetion)
  getValidator: (form)->
    $form = $ form
    return $.data( $form[0], "validator" )
}

##### 缓存版ajax
App.util.cjax = App.util.createCacheableAjax()