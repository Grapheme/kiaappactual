class window.AnimationAbstract
  type: 'abstract'

  constructor: (from, to, options) ->
    @options = {
      callback: () ->
        console.debug "#{@type} animation is done"
    }

    @objects = {from: from, to: to}
    $.extend @options, options

    return @

  forward: () ->
    @direction = 'forward'
    return @

  back: () ->
    @direction = 'back'
    return @

  run: (callback = false) ->
    # Set global flag that animation is running now
    window.Animation.isAnimate = true

    @["_#{@direction}"] () =>
      window.Animation.isAnimate = false
      if callback
        callback @objects.to

  resize: (planes) ->
    @_resize(planes)

$ ->
  window.animationTypes = {}