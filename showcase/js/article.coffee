class window.Article
  article: null # Main Article wrapper

  base: # Rotated Plane content size
    width: 0
    height: 0

  planes: {} # Planes with content

  animationType: 'slide'

  currentType: null

  constructor: (object = 'article') ->
    @article = $(object)
    @initResize()

  show: (page, content, isNew = false, direction = 'forward', callback = false) ->
    if not page
      return

    newArticle = $('<article />').addClass 'new'
    $('body').attr 'id', "body_#{page.alias}"
    newArticle.attr('id', page.alias).html content

    @article.after newArticle
    @changePage page, newArticle, isNew, direction, callback


  initResize: () ->
    $(window).on 'resize', (event) =>
      @resize()

    @resize()

  resize: (article = @article) ->
    height = window.innerHeight
    $(article).height height

    @infoBlocksPosition()
    if window.Animation
      window.Animation.resize()

  infoBlocksPosition: () ->
    infoBlocks = $('.infoBlock:not(.fixed)')
    buttons = $('.footerButtons')
    buttonsTop = buttons.offset().top
    infoBlocks.each (index, object) =>
      bottom = Math.round($('.description', object).offset().top + $('.description', object).height())
      bottomAbs = bottom + parseInt($(object).css('padding-bottom'))
      if bottomAbs > buttonsTop
        padding = bottomAbs - buttonsTop
        if padding < 0 then padding = 0
      else
        padding = 0

      $(object).css 'padding-bottom', padding

  changePage: (page, newArticle, isNew, direction, callback = false) ->

    window.Animation.init direction, @article, newArticle, {
      type: @animationType
    }

    window.Animation.run () =>
      $(@article).remove()
      @article = newArticle

      @article.removeClass 'new'
      location.hash = page.alias
      window.Animation.showInfoBlocks $('.plane.right', @article)

      if callback
        callback()










