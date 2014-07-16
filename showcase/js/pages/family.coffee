class FamilyPage
  currentMedia: null

  constructor: () ->
    @_init()

  _init: () ->
    @carsContainer = $('article#family .carsContainer')
    @car = $('article#family .familyCar')

    window.Animation.addPageCallback () =>
      @pageStart()

    window.Animation.addResizeCallback () =>
      @_resize()

    @image = new Image()

  pageStart: () ->
    @_resize()

  getWidth: () ->
    planes = window.Animation.getPlanes $('article#family')
    dummy = $('article#family .carDummy')
    dummyWidth = $(dummy).width()
    offset = $('article#family').width() - parseInt($('.planeWrapper',planes.right).css('min-width'))-50
    width = dummyWidth + offset
    return width


  _resize: () ->
    planes = window.Animation.getPlanes $('article#family')
    width = @getWidth()

    @carsContainer.css {
      width: width * 0.9
      height: $('article#family').height()
    }

    height = $('article#family').height()

    @car.css {
      width: '100%'
      height: height
    }

    picHeight = @getHeight()
    @resizeLinks picHeight

  resizeLinks: (height) ->
    links = $('.links', @car)

    marginTop = ($('article#family').height()-height)/2
    links.css {
      height: height
      marginTop: marginTop
    }
    linkCount = $('a', links).length
    linkHeight = height/linkCount
    linkMargin = linkHeight * Math.tan(window.Animation.rotateAngleRad)

    $('a', links).each (index, link) =>
      margin = (linkCount-index-1) * linkMargin * 0.9
      $(link).css {
        height: linkHeight
        width: linkHeight*1.25
        marginLeft: margin
      }


  getHeight: () ->
    @previousMedia = @currentMedia
    @_detectCurrentMedia()
    if @previousMedia != @currentMedia
      src = @car.css('background-image').replace('url(','').replace(/"|\)/g,'')
      console.debug src
      @image.src = src
      @proportion = @image.height / @image.width

    height = @car.width() * @proportion
    return height

  _detectCurrentMedia: () ->
    if parseInt($('body').css('z-index')) == 1
      @currentMedia = 'normal'
    else
      @currentMedia = 'big'



$ ->
  window.family = new FamilyPage()