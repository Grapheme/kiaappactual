class window.Animation
  isAnimate: false
  direction: 'forward'
  objects:
    from: null
    to: null
  options: null
  rotateAngle: 18
  rotateAngleRad: null
  pageCallbacks: []
  resizeCallbacks: []

  init: (direction, from, to, options) ->
    @direction = direction
    @objects.from = from
    @objects.to = to
    @options = options
    @rotateAngleRad = @rotateAngle*Math.PI/180
    @planes = @getPlanes(@objects.to)
    @AnimationObject = new window.animationTypes[options.type](@objects.from, @objects.to, @options)
    @prepare()

  run: (callback) ->
    @[@direction] () =>
      callback()

  forward: (callback) ->
    @AnimationObject.forward().run () =>
      @runPageCallbacks()
      callback()

  back: (callback) ->
    @AnimationObject.back().run () =>
      @runPageCallbacks()
      callback()

  resize: () ->
    if @AnimationObject
      @AnimationObject.resize()
      @runResizeCallbacks()

    if window.app
      window.app.article.infoBlocksPosition()

  overflow: (overflow = false) ->
    if overflow
      $('body').addClass 'overflowHidden'
    else
      $('body').removeClass 'overflowHidden'

  addPageCallback: (callback) ->
    @pageCallbacks.push callback

  runPageCallbacks: () ->
    for index, callback of @pageCallbacks
      callback()

    @pageCallbacks = []

  addResizeCallback: (callback) ->
    @resizeCallbacks.push callback

  runResizeCallbacks: () ->
    for index, callback of @resizeCallbacks
      callback()

  showInfoBlocks: (plane) ->
    infoBlock = $('.infoBlock:not(.custom)', plane)
    infoBlock.css 'opacity', 1

    window.app.article.infoBlocksPosition()

    $('h2, .description', infoBlock).hide()
    width = $('.titleLine', infoBlock).width()
    $('h2, .description', infoBlock).fadeIn('slow')
    if $('.titleLine',infoBlock).length
      $('.titleLine', infoBlock).css {
        width: 0
        opacity: 0
      }
      .animate {
        width: width
        opacity: 1
      }, {
        progress: (now, fx) =>
          mr = width - $(now.elem).width()
          $('.titleLine', infoBlock).css {
            marginRight: mr
          }
        duration: 300
        queue: false
      }
    else
      $('h2, .description', infoBlock).fadeIn('slow')

  hideInfoBlocks: (plane) ->
    infoBlock = $('.infoBlock:not(.custom)', plane)
    infoBlock.animate {
      opacity: 0
    }, {
      duration: 500
    }

  prepare: (planes = @planes, fullscreen = true) ->
    contentContainer = $('.planeWrapper', planes.right)
    @article = $(planes.right).closest 'article'

    @article.height window.innerHeight

    @originWidth = contentContainer.css 'min-width'

    width = if fullscreen then @article.width() else @originWidth

    properties = @calculatePlane width, @article.height()

    for prop, value of properties
      $(planes.right).css prop, value

    if $(planes.left).length
      $(planes.left).first().css 'height', @article.height()

    # Rotate content wrapper to angle
    window.Transitions.rotate planes.right, @rotateAngle

    # Rotate content to reverse angle for zero rotation result
    window.Transitions.rotate contentContainer, -@rotateAngle

    contentContainer.css
      width: @article.width()
      height: @article.height()

    planeContent = $('.planeContent', contentContainer)
    if planeContent.hasClass 'one'
      width = @article.width()
    else
      width = planeContent.width window.Animation.calc.baseWidth - window.Animation.calc.offsetLeft - 50

    planeContent.width width
    planeContent.height @article.height()

  getPlanes: (article) ->
    planes = {}
    planes.left = $('.plane.left', article)
    planes.right = $('.plane.right', article)
    return planes

  calculatePlane: (baseWidth, baseHeight) ->
    @calc = @getCalcObject(baseWidth, baseHeight)

    properties = {}
    properties.width = @calc.width
    properties.height = @calc.height
    properties.paddingTop = @calc.offsetY
    properties.top = -@calc.heightB
    properties.marginLeft = @calc.offsetLeft

    return properties

  getCalcObject: (baseWidth, baseHeight) ->
    angle = @rotateAngleRad

    if typeof baseWidth == "string"
      baseWidth = @getSizeInPixels(baseWidth)

    baseWidth = baseWidth + 50

    calc = {}
    calc.baseWidth = baseWidth
    calc.baseHeight = baseHeight
    calc.offsetX = baseHeight * Math.sin(angle)
    calc.offsetWidth = baseWidth + calc.offsetX
    calc.offsetY = calc.offsetWidth * Math.tan(angle)
    calc.width = calc.offsetWidth * Math.cos(angle)
    calc.heightA = baseHeight * Math.cos(angle)
    calc.heightB = calc.offsetWidth * Math.sin(angle)
    calc.height = calc.heightA+calc.offsetX
    calc.offsetLeft = calc.offsetY*Math.sin(angle)
    calc.offsetRight = calc.offsetLeft - baseWidth
    calc.offsetRight2 = (@article.width() - baseWidth) / Math.cos(angle) / Math.cos(angle)


    for prop, value of calc
      calc[prop] = Math.round(value)

    return calc

  getSizeInPixels: (size) ->
    if size.indexOf("%") > -1
      return @article.width()*parseFloat(size)/100

    if size.indexOf("px") > -1
      return parseInt(size)

window.Animation = new Animation()