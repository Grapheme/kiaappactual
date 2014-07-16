# Class for rotate page functionality
class RotatePage
  cars:
    ceed:
      image: 'img/3d/ceed.png'
    ceed_pro:
      image: 'img/3d/ceed_pro.png'

  current: 'ceed'
  currentMedia: null

  constructor: () ->
    @links = $('.carTitles a')
    @_init()

  _init: () ->
    @container = $('#rotateContainer')
    @arrows = @container.closest('.rotateWrapper').find('.rotateArrows')
    @arrows.hide()
    @_initRotate()
    @_initEvents()
    @_detectCurrentMedia()

    window.Animation.addResizeCallback () =>
      @_resize()

  _initRotate: () ->
    @container
    .addClass @current
    @wrapper = @container.closest('.rotateWrapper')
    @wrapper.css 'opacity', 0
    src = $('#rotateContainer').css 'background-image'
    if typeof src == "string"
      src = src.replace(/^url\(["']?/, '').replace(/["']?\)$/, '')

    @container.spritespin
      source: src
      width: parseInt @container.css 'min-width'
      height: parseInt @container.css 'min-height'
      frames: 24
      framesX: 6
      loop: false
      animate: false
      renderer: 'background'
      onInit: (event) =>
        @_showArrows()
        @api = @container.spritespin('api')
        @api.updateFrame 5
        $(@wrapper).animate {
          opacity: 1
        }, {
          duration: 1000
        }

  _initEvents: () ->
    $('.left', @arrows).on 'click', (event) =>
      event.preventDefault()
      @api.nextFrame()

    $('.right', @arrows).on 'click', (event) =>
      event.preventDefault()
      @api.prevFrame()

    $('a', '.carTitles').on 'click', (event) =>
      event.preventDefault()
      link = $(event.currentTarget)
      target = link.attr('href').replace '#', ''
      ul = $(event.target).closest('ul')
      @links.removeClass 'active'
      $(link).addClass 'active'
      @container.removeClass('ceed ceed_pro').addClass(target)

      $(@wrapper).animate {
        opacity: 0
      }, {
        duration: 1000
        complete: () =>
          @container.spritespin('destroy')
          @_initRotate()
      }


  _showArrows: () ->
    @arrows.fadeIn('slow')

  _resize: () ->
    @previousMedia = @currentMedia
    @_detectCurrentMedia()
    if @previousMedia != @currentMedia
      clearTimeout @timeout
      @timeout = setTimeout () =>
        @container.spritespin('destroy')
        @_initRotate()
      , 100


  _detectCurrentMedia: () ->
    if parseInt($('body').css('min-height')) == 0
      @currentMedia = 'normal'
    else
      @currentMedia = 'big'

$ ->
  window.rotatePage = new RotatePage()