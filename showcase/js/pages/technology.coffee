class TechnologyPage
  constructor: () ->
    @car = $('.technologyCar')

    @pageStart()

  pageStart: () ->
    @car.show().animate {
      top: 0
    }, {
      duration: 1000
      easing: 'easeOutQuad'
    }

    infoBlock = $('article#technology .infoBlock')
    infoBlock.css 'opacity', 1

    $('h2, .description', infoBlock).hide()
    width = $('.titleLine', infoBlock).width()

    $('.titleLine', infoBlock).css {
      width: 0
      opacity: 0
    }

    right = parseInt $(infoBlock).css 'right'
    infoWidth = parseInt $(infoBlock).css 'width'

    $('h2, .description', infoBlock).show()

    infoBlock.clearQueue().delay(600).css {
      right: -infoWidth
    }
    .animate {
      right: right
    }, {
      duration: 300
      easing: 'easeOutQuad'
      complete: () =>
        infoBlock.removeClass 'custom'
        $('.titleLine', infoBlock).animate {
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
    }

window.technology = new TechnologyPage()