class AnimationFade extends window.AnimationAbstract
  type: 'fade'
  durations:
    main: 2000

  _forward: (callback) ->
    @_base(callback)

  _back: (callback) ->
    @_base(callback)

  _base: (callback) ->
    @_prepare()
    @objects.to.fadeIn @durations.main, callback

  _prepare: () ->
    @objects.to.css
      left: 0
      top: 0

$ ->
  window.animationTypes.fade = AnimationFade