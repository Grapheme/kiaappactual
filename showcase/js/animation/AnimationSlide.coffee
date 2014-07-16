class AnimationSlide extends window.AnimationAbstract
  type: 'slide'
  durations:
    main: 600
    small: 300
    mirco: 100

  _forward: (callback) ->
    position = window.Animation.article.width() + window.Animation.article.height() / Math.cos(window.Animation.rotateAngleRad)
    @_stepOne position, () =>
      @_stepTwo () =>
        callback @objects.to
      @_stepThree()

  _back: (callback) ->
    position = -window.Animation.article.width()
    @_stepOne position, () =>
      @_stepTwo () =>
        callback @objects.to
      @_stepThree()

  _stepOne: (startPosition, callback) ->
    @objects.to.css
      left: startPosition

    planes = window.Animation.planes

    @objects.to.show().animate
      left: 0
    , {
        duration: @durations.main
        easing: 'easeOutCubic'
        queue: false
        progress: (now, fx) =>
          value = parseInt $(@objects.to).css 'left'
          $(@objects.to).css 'left', value
          @_alignBg()

        complete: () =>
          @_alignBg()
          callback()
      }

    $('.planeBg',planes.right).css
      display: 'block'
      opacity: 0
    .animate
        opacity: 1
      , {
          duration: @durations.main
          queue: false
        }


    @objects.from.animate
      opacity: 0
    , {
        duration: @durations.main
        easing: 'easeOutCubic'
        queue: false
      }

  _stepTwo: (callback) ->
    planes = window.Animation.planes
    article = window.Animation.objects.to
    if planes.left.length

      window.Animation.calculatePlane(window.Animation.originWidth, window.Animation.article.height())
      properties = {}
      if window.Animation.originWidth == "100%"
        properties.left = window.Animation.calc.offsetX
      else
        properties.left = window.Animation.article.width() - window.Animation.getSizeInPixels(window.Animation.originWidth)

      $(planes.right).animate properties
      , {
          duration: @durations.small
          easing: 'easeInCubic'
          queue: false
          progress: (now, fx) =>
            @_alignBg()

          complete: () =>
            @_alignBg()
            @halfSlide = new window.animationTypes.halfSlide @objects.from, @objects.to, {}
            callback()
        }

      planes.left.css
        display: 'block'
        opacity: 0
      .animate
          opacity: 1
        , {
            duration: @durations.small
            easing: 'easeInCubic'
            queue: false
          }
    else
      callback()

  _stepThree: (callback = null) ->
    planes = window.Animation.planes
    article = window.Animation.objects.to

    if $('.planeBgLayer2',planes.right).length
      layer = $('.planeBgLayer2',planes.right)

      layer.animate {
        marginTop: 0
        marginRight: 0
      }, {
        duration: 400
        queue: false
        easing: 'easeOutQuad'
        complete: () =>
          if callback
            callback()
      }

    else
      if callback
        callback()

  _alignBg: () ->
    planes = window.Animation.planes
    offset = $('.planeWrapper', planes.right).offset()
    planeBg = $('.planeBg', planes.right)

    offset.right = offset.left + planeBg.outerWidth()
    offset.bottom = offset.top + planeBg.outerHeight()
    outRight = offset.right - window.Animation.article.width()

    right = if $('article.popup').length then 0 else outRight

    planeBg.css {
      right: right
    }


  _resize: () ->
    planes = window.Animation.planes
    article = window.Animation.objects.to
    window.Animation.prepare (planes)

    if $('article.popup').length
      left = '-40%'
    else
      left = 0

    @objects.to.css {
      left: left
    }

    if $(planes.left).length
      properties = {}

      if window.Animation.originWidth == "100%"
        properties.left = window.Animation.calc.offsetX
      else
        properties.left = window.Animation.article.width()-window.Animation.getSizeInPixels(window.Animation.originWidth)

      if @halfSlide
        @halfSlide.offsetBack = properties.left
        properties = @halfSlide.getProperties(properties)

      $(planes.right).css properties


      if @halfSlide
        @halfSlide.resize(planes)

    @_alignBg()


$ ->
  window.animationTypes.slide = AnimationSlide