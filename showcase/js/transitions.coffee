class window.Transitions
  @rotate: (object, angle) ->
    $(object).css
      '-webkit-transform': 'rotate(' + angle + 'deg)',
      '-moz-transform': 'rotate(' + angle + 'deg)',
      '-ms-transform': 'rotate(' + angle + 'deg)',
      '-o-transform': 'rotate(' + angle + 'deg)',
      'transform': 'rotate(' + angle + 'deg)',
      'zoom': 1
