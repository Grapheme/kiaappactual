class window.Preloader
  images: [] # array of images
  allImages: []
  options:
    imageLoaded: null
    complete: null
  preloaded:
    normal: false
    big: false


  constructor: (options) ->
    $.extend @options, options

    $(window).on 'resize', (event) =>
      @_resize()

  setMedia: (media) ->
    @media = media
    @notMedia = if @media == 'normal' then '/big/' else '/normal/'
    return @

  init: (media, options) ->
    @setMedia media
    @completeOptions = options
    @prepare()
    @loadImages()

  _resize: () ->
    $('#splashScreen').css {
      width: window.innerWidth
      height: window.innerHeight
    }

  prepare: () ->
    k = 0 #iterator for adding images
    sheets = document.styleSheets #array of stylesheets
    i = 0 #loop through each stylesheet

    while i < sheets.length
      cssPile = "" #create large string of all css rules in sheet
      csshref = (if (sheets[i].href) then sheets[i].href else "window.location.href")
      baseURLarr = csshref.split("/") #split href at / to make array
      baseURLarr.pop() #remove file path from baseURL array
      @baseURL = baseURLarr.join("/") #create base url for the images in this sheet (css file's dir)
      @baseURL += "/"  unless @baseURL is "" #tack on a / if needed

      if document.styleSheets[i].cssRules #w3
        thisSheetRules = document.styleSheets[i].cssRules #w3
        j = 0

        while j < thisSheetRules.length
          cssPile += thisSheetRules[j].cssText
          j++
      else
        cssPile += document.styleSheets[i].cssText

      #parse cssPile for image urls and load them into the DOM
      imgUrls = cssPile.match(/[^\(]+\.(gif|jpg|jpeg|png)/g) #reg ex to get a string of between a "(" and a ".filename"

      if imgUrls? and imgUrls.length > 0 and imgUrls isnt "" #loop array
        @images = []
        images = jQuery.unique(jQuery.makeArray(imgUrls)) #create array from regex obj
        for img in images
          if img.indexOf(@notMedia) == -1
            @images.push img
      i++

  loadImages: () ->
    if @preloaded[@media]
      if @options.complete
        @options.complete(@completeOptions)
      return

    startIndex = 0

    @loadImage 0, () =>
      @preloaded[@media] = true
      if @options.complete
        @options.complete(@completeOptions)

  loadImage: (index, callback) ->
    image = @images[index]

    @allImages[index] = new Image()
    src = if (image[0] is "/" or image.match("http://") or image.match("https://")) then image else @baseURL + image #set src either absolute or rel to css dir

    src = src.replace '"',""
    $(@allImages[index])
    .attr("src", src)
    .load () =>
      if @options.imageLoaded
        @options.imageLoaded(index, @images.length)
      if @images[index+1]
        @loadImage index+1, callback
      else
        callback()
