class PropertiesPage
  constructor: () ->
    @links = $('.carTitles a')

    @events()

  events: () ->
    @links.on 'click', (event) =>
      event.preventDefault()
      link = $(event.currentTarget)
      target = link.attr('href').replace '#', ''
      @show target, link

  show: (target, object) ->
    @links.removeClass 'active'
    $(object).addClass 'active'


    $(".infoBlock .right:not(\##{target})").fadeOut 'slow', () =>
      $("article#properties .infoBlock").removeClass('gt gt_pro').addClass(target)
      $("\##{target}").fadeIn 'slow'

$ ->
  window.properties = new PropertiesPage()