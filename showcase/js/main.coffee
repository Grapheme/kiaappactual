class Application
  constructor: ->
    @firstLoad = true
    @initMedia()
    @initObjects()
    @initSplash()

  initMedia: () ->
    @currentMedia = switch parseInt $('body').css('z-index')
      when 1 then 'normal'
      when 2 then 'small'
      when 3 then 'big'

      else 'normal'


  initObjects: () ->
    @article = new Article()
    @navigation = new Navigation()
    @menu = new Menu()
    @scroll = new Scroll {
      isMaximum: () =>
        $('.gotoNext').trigger 'click'
      isMinimum: () =>
        $('.gotoBack').trigger 'click'
    }
    @preloader = new Preloader {
      imageLoaded: (index, total) ->
        percent = Math.round(index/total*100)
        progressLineRight = "#{100 - percent}%"
        $('#splashScreen .progressLine').css {
          right: progressLineRight
        }
        $('#splashScreen .informer').text "#{percent}%"
      complete: (options) =>
        @menu.initData(@navigation.pages)
        @hideSplash()
        @article.show options.page, options.content, false, 'forward', () =>
          setTimeout () =>
            @showNavigation()
            if @navigation.isLast options.page
              $('.gotoNext').hide()
          , 1000
          @events()
    }

  start: () ->
    @initShare()
    @initGA()
    @navigation.init (page, content) =>
      @preloader.init @currentMedia, {
        page: page
        content: content
      }


  popup: (alias) ->
    @hideNavigation()
    @menu.hideMenu()
    @menu.disable()
    $('.tooltipsLayer').fadeOut 'slow'
    html = @navigation.loadHtml alias, (html) =>
      newArticle = $('<article />').addClass 'new popup'
      newArticle.attr('id', alias).html html

      $(@article.article).after newArticle
      @popupAnimation = new window.animationTypes.popup @article.article, newArticle, {}
      planes = window.Animation.getPlanes newArticle
      window.Animation.prepare planes, false
      @popupAnimation.forward().run () =>
        window.Animation.showInfoBlocks planes.right
        $('.popupClose').fadeIn('slow')



  popupClose: (callback = null) ->
    @menu.hideMenu()
    $('.popupClose').fadeOut('slow')
    @popupAnimation.back().run () =>
      @showNavigation()
      @menu.enable()
      $('.tooltipsLayer').fadeIn 'slow'
      @popupAnimation = null
      if callback
        callback()



  initShare: () ->
    blockMenuRight = $("#share-block")
    $("#share-menu").click =>
        if blockMenuRight.is(':animated')
          return
        unless blockMenuRight.hasClass("active-menu")
          blockMenuRight.addClass "active-menu"
          blockMenuRight.animate
            width: "318"
          , =>
            @shareFlag = true
            return
        else
          blockMenuRight.animate
            width: "0"
          , =>
            blockMenuRight.removeClass "active-menu"
            return

  initGA: () ->
    gAnalytics = event: ->
      data = undefined
      data = $(this).data()
      ga "send", "event", "button", "click", data.event
      return

    $(".ga-btn").on "click", gAnalytics.event

  initSplash: () ->
    $('#splashScreen').css {
      width: window.innerWidth
      height: window.innerHeight
    }

    $('#splashScreen .progressLine').css 'right', '100%'
    $('#splashScreen .informer').text ''

  showSplash: (callback = null) ->
    $('#splashScreen .progressLine').css 'right', '100%'
    $('#splashScreen .informer').text ''
    $('#splashScreen').show().css {
      width: window.innerWidth
      height: window.innerHeight
    }
    .animate {
      opacity: 1
    }, {
      duration:1000
      complete: () ->
        if callback
          callback()
    }

  hideSplash: (callback = null) ->
    $('.header').fadeIn('slow')
    $('#splashScreen').show().css {
      opacity: 1
    }
    .animate {
      opacity: 0
    }, {
      duration:1000
      complete: () =>
        $('#splashScreen').hide()
        $(document).trigger('hideSplash')
        if not @firstLoad
          $(window).trigger 'resize'
        @firstLoad = false

        if callback
          callback()
    }

  goto: (alias) ->
    if window.Animation.isAnimate
      return
    page = @navigation.getPageByAlias alias
    @menu.hideMenu()
    @navigation.goto page.index, (page, html) =>
      if @navigation.isLast page
        @hideArrow $('.gotoNext')
      else
        @showArrow $('.gotoNext')
      @article.show page, html, true, 'forward'

  next: () ->
    @menu.hideMenu()
    @navigation.next (page, html) =>
      if window.Animation.isAnimate
        return
      if @navigation.isLast page
        @hideArrow $('.gotoNext')
      else
        @showArrow $('.gotoNext')

      if page
        @article.show page, html, true, 'forward'

  back: () ->
    @menu.hideMenu()
    if @popupAnimation
      @popupAnimation.back().run()
    @navigation.previous (page, html) =>
      if window.Animation.isAnimate
        return

      if @navigation.isLast(page) and @navigation.current != 0
        @hideArrow $('.gotoNext')
      else
        @showArrow $('.gotoNext')

      if page
        @article.show page, html, true, 'back'
      else
        @showFade () ->
          window.location.href = '../'

  events: () ->
    $(document).on 'click', '.gotoNext', (event) =>
      event.preventDefault()
      if @popupAnimation
        @popupClose () =>
          @next()
      else
        @next()


    $(document).on 'click', '.gotoBack', (event) =>
      event.preventDefault()
      if @popupAnimation
        @popupClose () =>
          @back()
      else
        @back()


    $(document).on 'click', '.popupClose', (event) =>
      event.preventDefault()
      @popupClose()

    $(document).on 'keydown', (event) =>
      @menu.hideMenu()
      switch event.keyCode
        when 39
          $('.gotoNext').trigger 'click'
          event.preventDefault()
          return
        when 37
          $('.gotoBack').trigger 'click'
          event.preventDefault()
          return
        else
          return

    $(window).on 'resize', () =>
      @resize()

  resize: () ->
    @previousMedia = @currentMedia
    @initMedia()

    if @popupAnimation
      @popupAnimation.resize()

    if @previousMedia != @currentMedia
      if @preloader.preloaded[@currentMedia]
        return
      @navigation.goto @navigation.current, (page, content) =>
        @showSplash () =>
          @preloader.options.complete = () =>
            @hideSplash()
          @preloader.init @currentMedia, {
            page: page
            content: content
          }

  showNavigation: () ->
    navigation = $('footer .footerButtons')

    navigation.css('top','100px').show().animate {
      top: -75
      opacity: 1
    }, {
      queue: false
      duration: 500
      easing: 'easeOutBack'
    }

  hideNavigation: () ->
    navigation = $('footer .footerButtons')
    navigation.show().animate {
      top: 100
      opacity: 0
    }, {
      queue: false
      duration: 500
      easing: 'easeOutBack'
    }

  showFade: (callback) ->

    fade = $('<div />').hide().addClass 'fadeSplash'
    $('body').append fade
    fade.show().css {
      opacity: 0
      width: window.innerWidth
      height: window.innerHeight
    }
    .animate {
      opacity: 1
    }, {
      duration: 500
      complete: () ->
        if callback
          callback()
    }

  showArrow: (arrow) ->
    if $(arrow).is ':hidden'
      arrow.clearQueue().show().animate {
        top: -15
        opacity: 1
      }, {
        duration: 500
        easing: 'easeOutBack'
      }


  hideArrow: (arrow) ->
    if $(arrow).is ':visible'
      arrow.clearQueue().animate {
        top: -100
        opacity: 0
      }, {
        duration: 500
        easing: 'easeInBack'
        complete: () ->
          $(arrow).hide()
      }



$ ->
  window.app = new Application()
  window.app.start()

