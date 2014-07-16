class window.Tooltip
  constructor: (options) ->
    @initVars()
    $.extend @options, options
    @animationStatus = false
    @render()

  render: () ->
    @objects.point = $('<a />')
    .addClass "tooltip #{@options.type}"
    .attr 'id', @options.id
    .hide()
    @options.container.append @objects.point

    @options.right = parseInt @objects.point.css 'right'

    @objects.container = $('<div />')
    .addClass('tooltipContainer')
    .appendTo @objects.point

    @objects.image = $('<div />')
    .addClass('image')
    .appendTo @objects.container

    @objects.sattelite = $('<div />')
    .addClass 'sattelite'
    .appendTo @objects.container

    @objects.background = $('<div />')
    .addClass 'tooltipBackground'
    .addClass @options.color
    .css 'left', @getBackgroundPosition()
    .appendTo @objects.container

    @objects.title = $('<div />')
    .addClass 'title'
    .text @options.title
    .appendTo @objects.background

    @objects.link = $('<a />')
    .addClass 'link'
    .appendTo @objects.container

    @initEvents()

  getBackgroundPosition: () ->
    left = parseInt($(@objects.point).css('right')) + $(@objects.container).width()
    return left

  initEvents: () ->
    @rotateSattelite()

    @objects.link.on 'click', (event) =>
      event.preventDefault()
      window.app.popup @options.id

    @objects.link.on 'mouseenter', (event) =>
      @showTooltip()

    @objects.link.on 'mouseout', (event) =>
      @hideTooltip('fast')

  resize: () ->
    @objects.background.css 'left', @getBackgroundPosition()


  showTooltip: () ->
    @animationStatus = 'show'
    @objects.sattelite.fadeOut('slow')

    @objects.image.clearQueue().stop().animate {
      'opacity': 0
    }, {
      duration: 500
      queue: false
    }

    @objects.background.clearQueue().stop().animate {
      left:0
    }, {
      duration: 500
      queue: false
      easing: 'easeOutBack'
      complete: () =>
        @animationStatus = false
    }

  hideTooltip: (speed = 'normal') ->
    @animationStatus = 'hide'
    @objects.sattelite.fadeIn('fast')

    @objects.image.clearQueue().stop().animate {
      'opacity': 1
    }, {
      duration: 300
      queue: false
    }

    animation = switch speed
      when 'normal'
        {
          duration: 500
          easing: 'easeInBack'
          queue: false
        }
      else
        {
          duration: 300
          queue: false
        }
    animation.complete = () =>
      @animationStatus = false

    @objects.background.clearQueue().stop().animate {
      left:@getBackgroundPosition()
    }, animation


  show: () ->
    @objects.point.fadeIn @options.durations.slide

#    @objects.point.show().animate {
#      right: @options.right
#    }, {
#      duration: @options.durations.slide
#      queue: false
#      easing: 'easeOutBack'
#    }

  rotateSattelite: () ->
    @objects.sattelite.css {
      transform: "rotate(#{@options.degree}deg)"
    }
    ++@options.degree
    if @options.degree == 360
      @options.degree = 0
    @rotateTimer = setTimeout () =>
      @rotateSattelite()
    , 15

  initVars:() ->
    @objects = {
      point: null
      satellite: null
      line: null
      title: null
    }

    @options = {
      container: null
      id: ''
      title: ''
      type: 'right'
      position:
        top: 100
        right: 100
      durations:
        rotate: 600
        slide: 1000
      degree: 135
    }

  debug: () ->
    console.debug @