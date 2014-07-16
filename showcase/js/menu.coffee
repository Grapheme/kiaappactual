class window.Menu
  constructor: () ->
    @wrapper = null
    @container = null
    @isVisible = false
    @initialized = false
    @_init()
    @_events()

  _init: () ->
    @wrapper = $('<div />')
      .addClass 'mainMenu'
      .hide()

    @container = $('<div />')
      .addClass 'mainMenuContainer'
      .appendTo @wrapper

    @toggle = $('<a />')
      .addClass 'mainMenuToggle'

    @toggleIcon = $('<i />')
      .addClass 'mainMenuIcon'
      .appendTo @toggle

    @list = $('<ul />')
      .appendTo @container

    $('body').append @wrapper
    $('body').append @toggle

  initData: (pages) ->
    if @initialized
      return

    @initialized = true
    for page in pages
      if page.inMenu
        li = $('<li />')
          .appendTo @list

        a = $('<a />')
          .text page.title
          .attr 'href', "##{page.alias}"
          .appendTo li

  _events: () ->
    @toggle.on 'click', (event) =>
      event.preventDefault()
      if @isVisible
        @hideMenu()
      else
        @showMenu()

    $(document).on 'click', '.mainMenu a', (event) =>
      event.preventDefault()
      event.stopPropagation()
      href = $(event.target).attr('href').replace('#','')
      window.app.goto href
      if window.app.popupAnimation
        window.app.popupAnimation.back().run()

      @hideMenu()

    $('html').on 'click', (event) =>
      if $(event.target).hasClass 'mainMenuIcon'
        return
      if $(event.target).closest('.mainMenu').length == 0 and @isVisible
        @hideMenu()

    $(window).on 'resize', (event) =>
      @resize()

    @resize()

  resize: () ->
    if window.Animation.article
      $(@wrapper).height window.Animation.article.height()
    else
      $(@wrapper).height window.innerHeight

  showMenu: () ->
    if @isVisible
      return
    @enable()
    @isVisible = true
    @moveArticle 'forward'

    @wrapper.clearQueue().css {
      left: -@wrapper.width()
    }
    .show()
    .animate {
      left: 0
    }, {
      duration: 500
      queue: false
    }
    @toggle.addClass('opened').animate {
      left: @wrapper.width() - 60
    }, {
      queue: false
    }
    window.Transitions.rotate @toggle, 90

  hideMenu: () ->
    if @isVisible == false
      return

    @isVisible = false
    @moveArticle 'back'

    @wrapper.clearQueue()
    .animate {
      left: -@wrapper.width()
    }, {
      duration: 1000
      complete: () =>
        @wrapper.hide()
    }

    @toggle.removeClass('opened').animate {
      left: 30
    }, {
      duration: 500
      queue: false
    }
    window.Transitions.rotate @toggle, 0

  disable: () ->
    @toggle.fadeOut('slow')

  enable: () ->
    @toggle.fadeIn('slow')

  moveArticle: (direction = 'forward') ->
    article = $('article')
    @animation = new window.animationTypes.menu article, article, {}
    @animation[direction]().run()
