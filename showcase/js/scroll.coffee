class window.Scroll
  currentMedia: null

  constructor: (options = {}) ->
    @options = {
      isMaximum: () ->
        console.debug 'isMaximum'
      isMinimum: () ->
        console.debug 'isMinimum'
      acceleration: 0
      accBraking: 10
      braking: 0
      currentSpeed: 0
      edge: 500
    }
    @isAnimate = false
    $.extend @options, options
    @init()

  init: () ->
    @objects = {
      scroller: $('#scroller')
      wrapper: $('#scroller').closest('.scrollerWrapper')
    }

    window.Animation.addResizeCallback () =>
      @_resize()

    @_setInit()

  _setInit: () ->
    src = $(@objects.wrapper).css 'background-image'
    src = src.replace(/^url\(["']?/, '').replace(/["']?\)$/, '')

    $(@objects.scroller).css {
      backgroundImage: 'none'
    }
    .spritespin
        source: src
        width: parseInt @objects.wrapper.css 'width'
        height: parseInt @objects.wrapper.css 'height'
        frames: 55
        framesX: 11
        loop: false
        behavior: false
        animate:  false
        renderer: 'background'
        onInit: (event) =>
          @api = @objects.scroller.spritespin('api')
          @api.updateFrame 26
          @events()
          @start()

  start: () ->
    @ticTimer = setInterval () =>
      @tic()
    , 1

  events: () ->
    mousewheelevt = if (/Firefox/i.test(navigator.userAgent)) then "DOMMouseScroll" else "mousewheel"
    if (document.attachEvent)
      document.attachEvent "on"+mousewheelevt, (event) =>
        @wheel(event)
    else if (document.addEventListener)
      document.addEventListener mousewheelevt, (event) =>
        @wheel(event)
      , false

    if (navigator.userAgent.indexOf("Safari") > -1) and navigator.userAgent.indexOf("Chrome") == -1

      $('body').on 'DOMMouseScroll mousewheel touchmove', (event) =>
        @wheel event

  wheel: (event) ->
    if @isAnimate
      return

    if (/Firefox/i.test(navigator.userAgent))
      deltaY = event.detail
    else
      deltaY = event.deltaY

    if (navigator.userAgent.indexOf("Safari") > -1) and navigator.userAgent.indexOf("Chrome") == -1
      deltaY = -deltaY

    if deltaY > 0
      @options.acceleration = @options.acceleration+deltaY*3

    if deltaY < 0
      @options.braking = @options.braking-deltaY*3

  tic: () ->
    @options.acceleration = @options.acceleration - @options.accBraking
    if @options.acceleration < 0 then @options.acceleration = 0

    @options.braking = @options.braking - @options.accBraking
    if @options.braking < 0 then @options.braking = 0

    difference = @options.acceleration - @options.braking

    @options.currentSpeed = @options.currentSpeed + difference
    if @options.currentSpeed != 0
      @options.currentSpeed = @options.currentSpeed/3

    if Math.abs(@options.currentSpeed) < @options.accBraking then @options.currentSpeed = 0
    @render()
    if @options.currentSpeed < -@options.edge
      @options.isMinimum()
      clearInterval @ticTimer
      @reset()
      return

    if @options.currentSpeed > @options.edge
      @options.isMaximum()
      clearInterval @ticTimer
      @reset()
      return

  reset: () ->
    @isAnimate = true
    $('<div />').css {
      left: @options.currentSpeed
    }
    .animate {
      left: 0
    }, {
      duration: 500
      easing: 'easeOutBack'
      progress: (now, fx) =>
        @options.currentSpeed = parseInt $(now.elem).css 'left'
        @render()
      complete: () =>
        @isAnimate = false
        @options.currentSpeed
        @options.acceleration = 0
        @options.braking = 0
        @start()
    }

  render: () ->
    speed = Math.abs(@options.currentSpeed)
    direction = if speed!=0 then @options.currentSpeed/speed else 0
    percent = speed / @options.edge
    framesDelta = Math.round(26 * percent)

    if framesDelta > 27 then framesDelta = 27
    @api.updateFrame 27 + direction * framesDelta

  _resize: () ->
    @previousMedia = @currentMedia
    @_detectCurrentMedia()

    console.debug @previousMedia, @currentMedia

    if @previousMedia != @currentMedia
      console.debug 'change'
      clearTimeout @timeout
      @timeout = setTimeout () =>
        $(@objects.scroller).spritespin('destroy')
        @_setInit()
      , 100

  _detectCurrentMedia: () ->
    if $('body').css('z-index')=="1" or $('body').css('z-index')=="2"
      @currentMedia = 'normal'
    else
      @currentMedia = 'big'
