class AnimationMenu extends window.AnimationAbstract
  type: 'menu'
  durations:
    main: 1000

  _forward: (callback) ->
    window.Animation.isAnimate = false
    @objects.from.animate {
      left: "+=100"
#      width: "-=100"
    }, {
      duration: @durations.main
      queue: false
      complete: () ->
        callback()
    }

  _back: (callback) ->
    window.Animation.isAnimate = false
    @objects.from.animate {
      left: "-=100"
#      width: "+=100"
    }, {
      duration: @durations.main
      queue: false
      complete: () ->
        callback()
    }

$ ->
  window.animationTypes.menu = AnimationMenu