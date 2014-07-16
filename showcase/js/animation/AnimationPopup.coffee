class AnimationPopup extends window.AnimationAbstract
  type: 'popup'
  durations:
    big: 1000
    main: 700
    small: 500
    mirco: 200

  _forward: (callback) ->
    @originwidth = window.Animation.originWidth
    position = @objects.from.width() + @objects.from.height() / Math.cos(window.Animation.rotateAngleRad)
    endPosition = @objects.from.width() - parseInt(@originwidth)
    @_stepOne position, endPosition, @durations.main, 0, () =>
      callback @objects.to

    @objects.from.delay(200).animate
      left: '-40%'
    , {
        queue: false
        duration: @durations.big
        easing: 'easeOutCubic'
      }

  _back: (callback) ->
    position = @objects.from.width() - parseInt(@originwidth)
    endPosition = @objects.to.width() + @objects.to.height() / Math.cos(window.Animation.rotateAngleRad)
    @_stepOne position, endPosition, @durations.big, 300, () =>
      @objects.to.remove()

    @objects.from.animate
      left: 0
    , {
        duration: @durations.main
        easing: 'easeOutQuad'
        queue: false
        complete: () ->
          callback()
      }

  _stepOne: (startPosition, endPosition, speed, delay, callback) ->
    @objects.to.css
      left: startPosition

    planes = window.Animation.getPlanes @objects.to
    $('.planeBg', planes.right).css 'right', endPosition
    $('.planeContent', planes.right).css 'margin-right', -endPosition
    @objects.to.show().delay(delay).animate
      left: endPosition
      width: @originWidth
    , {
        duration: speed
        easing: 'easeOutQuad'
        complete: () =>
          callback()
      }

    $(planes.right).css
      left: window.Animation.calc.offsetX+20

    $('.planeBg',planes.right).css
      display: 'block'
      opacity: 0
    .animate
        opacity: 1
      , {
          duration: @durations.small
          queue: false
        }

  _alignBg: (offset) ->
    planes = window.Animation.getPlanes @objects.to
    $('.planeBg', planes.right).css 'right', offset

  _resize: (planes) ->
    planes = window.Animation.getPlanes @objects.to
    window.Animation.prepare planes, false

    endPosition = @objects.from.width() - parseInt(@originwidth)
    @objects.to.css {
      left: endPosition
      width: @originWidth - endPosition
    }

    $(planes.right).css
      left: window.Animation.calc.offsetX+20

    $('.planeBg', planes.right).css 'right', endPosition
    $('.planeContent', planes.right).css 'margin-right', -endPosition



$ ->
  window.animationTypes.popup = AnimationPopup