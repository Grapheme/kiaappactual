class AnimationHalfSlide extends window.AnimationAbstract
  type: 'halfSlide'
  durations:
    main: 1200

  constructor: (from, to, options) ->
    super
    planes = window.Animation.getPlanes @objects.to
    @offsetBack = parseInt $(planes.right).css 'left'
    @_init()
    @forward()
    return @

  _forward: (callback) ->
    planes = window.Animation.getPlanes @objects.to
    @back()
    offset = @offsetBack + @getOffset()
    @_base(callback, offset)


  _back: (callback) ->
    @forward()
    @_base(callback, @offsetBack)


  _base: (callback, offset) ->
    planes = window.Animation.getPlanes @objects.to
    @arrow.removeClass('forward back').addClass @direction

    switch @direction
      when 'back'
        window.Animation.hideInfoBlocks(planes.right)
      else
        window.Animation.hideInfoBlocks(planes.left)

    $(planes.right).animate {
      left: "#{offset}"
    }, {
      duration: @durations.main/2
      easing: 'easeInOutQuad'
      queue: false
      progress: (now, fix) =>
        value = parseInt $(planes.right).css 'left'
        $(planes.right).css 'left', value
        @arrowAlign()
        @_alignBg()
      complete: =>
        @arrowAlign()
        switch @direction
          when 'back'
            window.Animation.showInfoBlocks(planes.left)
          else
            window.Animation.showInfoBlocks(planes.right)
        callback()
    }

  _alignBg: () ->
    planes = window.Animation.planes
    offset = $('.planeWrapper', planes.right).offset()
    offset.right = offset.left + $('.planeBg',planes.right).outerWidth()
    offset.bottom = offset.top + $('.planeBg',planes.right).outerHeight()
    outRight = Math.round(offset.right - window.Animation.article.width())

    console.debug outRight

    $('.planeBg', planes.right).css 'right', outRight

  _init: () ->
    planes = window.Animation.getPlanes @objects.to
    if $(planes.left).hasClass('noSlide')
      return

    @arrow = $('<a class="slidesArrow"><div class="placer"></div></a>').appendTo @objects.to
    placer = $('.placer', @arrow)
    $(@arrow).on 'click', (event) =>
      @run()

    angle = window.Animation.rotateAngle * Math.PI / 180
    window.Transitions.rotate @arrow, window.Animation.rotateAngle

    width = $(@arrow).width()
    $(@arrow).css {left: window.Animation.calc.offsetX}
    $(placer).css {width: 0}

    $(placer).animate {
      width: width
    }, {
      duration: @durations.mirco
      progress: (now, fx) =>
        ml = width - $(now.elem).width()
        $(now.elem).css {
          marginLeft: ml
        }
    }

  getProperties: (properties) ->
    @options.offset = @getOffset()
    switch @direction
      when 'forward'
        properties.left = @offsetBack
      else
        properties.left = @offsetBack + @getOffset()
    return properties

  _resize: (planes) ->
    @options.offset = @getOffset
    @arrowAlign()

  arrowAlign: () ->
    planes = window.Animation.getPlanes @objects.to
    calc = window.Animation.getCalcObject(@objects.to.width(),@objects.to.height())
    left = parseInt $(planes.right).css 'left'
    offset = window.Animation.calc.offsetX + left - @offsetBack
    $(@arrow).css {left: offset}

  getOffset: () ->
    calc = window.Animation.getCalcObject(@objects.to.width(),@objects.to.height())
    return (@objects.to.width() - calc.offsetX)




$ ->
  window.animationTypes.halfSlide = AnimationHalfSlide