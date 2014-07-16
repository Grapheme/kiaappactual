class window.Navigation

  url:
    map: "data/pages.json"     # main navigation map
    html: "data/pages/"        # folder with all pages html
  pages: []                     # pages structure form source json
  current: 0                    # index of current page
  content:                      # html content of current and nearest pages
    previous: null
    current: null
    next: null

  constructor: (current = 0) ->
    @current = current

  init: (callback) ->
    $.getJSON @url.map, (data) =>
      i=0
      for page in data.pages
        page.index = i
        @pages.push page
        i++

      if location.hash != ""
        hash = location.hash.replace "#", ""
        page = @getPageByAlias hash
        if page
          @current = page.index

      @loadAllPages () =>
        @goto @current, callback

  loadAllPages: (callback) ->
    startIndex = @pages[0].index
    @loadPage(startIndex, callback)

  loadPage: (index, callback) ->
    if @pages[index]
      alias = @pages[index].alias
      @loadHtml alias, (data) =>
        @pages[index].content = data
        if @pages[index+1]
          @loadPage index+1, () =>
            callback()
        else
          callback()

  next: (callback) ->
    @goto @current+1, callback

  previous: (callback) ->
    @goto @current-1, callback

  getPageByAlias: (alias) ->
    for page in @pages
      if page.alias == alias
        return page

    return null

  isLast: (page) ->
    if page
      return (page.index == @pages.length-1)
    else
      return true


  goto: (index, callback) ->
    if not @pages[index] or window.Animation.isAnimate
      callback null
      return

    @current = index

    callback @pages[index], @pages[index].content

  preloadNext: () ->
    @content.previous = @content.current
    @content.current = @content.next

    @load @current+1, (data) =>
      @content.next = data

  preloadPrevious: () ->
    @content.next = @content.current
    @content.current = @content.previous

    @load @current-1, (data) =>
      @content.previous = data

  load: (index, callback) ->
    page = @pages[index]
    if page
      @loadHtml page.alias, callback
    else
      callback null

  loadHtml: (alias, callback) ->
    $.ajax
      url: "#{@url.html}#{alias}.html"
      success: (data) =>
        callback(data)
