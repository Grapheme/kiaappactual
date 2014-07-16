class Exterior

  constructor: () ->
    @tooltipsData =
      lights:
        id: 'lights'
        title: 'Передние и задние светодиодные фонари'
        type: 'bottom'
        color: 'white'
      bumper:
        id: 'bumpers'
        title: 'Cпортивные бамперы'
        type: 'right'
        color: 'red'

    @tooltips = []

    @layer = null

    @renderTooltips()
    @_events()

    window.Animation.addResizeCallback () =>
      @_resize()

  renderTooltips: () ->
    @layer = $('<div />').addClass('tooltipsLayer').css {
      width: $('article#exterior').width()
      height: $('article#exterior').height()
    }
    .appendTo('article#exterior')

    for id, tooltipData of @tooltipsData
      tooltip = new window.Tooltip {
        container: @layer
        id: tooltipData.id
        title: tooltipData.title
        type: tooltipData.type
        color: tooltipData.color
      }
      @tooltips.push tooltip

    setTimeout () =>
      @showTooltips()
    , 1500

    return

  _events: () ->
    $(window).on 'resize', (event) =>
      @layer.css {
        width: $('article#exterior').width()
        height: $('article#exterior').height()
      }

  _resize: () ->
    for tooltip in @tooltips
      tooltip.resize()

  showTooltips: () ->
    for tooltip in @tooltips
      tooltip.show()

$ ->
  window.exterior = new Exterior()