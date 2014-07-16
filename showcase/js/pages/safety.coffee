class SafetyPage

  data: {
    items: {
      safetyIcon_1:
        title: "ABS"
        description: "Антиблокировочная система (ABS) cледит за тем, чтобы при торможении между колесами автомобиля и дорожным покрытием не терялось трение. Даже при внезапном торможении, вы сохраните контроль над автомобилем."
      safetyIcon_2:
        title: "Система помощи при подъеме"
        description: "Система помощи при подъеме помогает при движении по неровной дороге и на крутых подъемах: автомобиль не скатывается назад, что избавляет вас от необходимости пользоваться стояночным тормозом. Повышается безопасность водителя и пешеходов."
      safetyIcon_3:
        title: "Подушки безопасности"
        description: "Подушки безопасности срабатывают при резком столкновении автомобиля с препятствием.  То, какая именно подушка «подстрахует» водителя, зависит от стороны и направления удара. На KIA cee’d GT установлены датчики удара. При аварии они обрабатывают информацию о силе столкновения."
      safetyIcon_4:
        title: "Шторки безопасности"
        description: "Шторки безопасности защитят голову водителя и пассажиров при боковом ударе. В момент аварии срабатывает механизм, и шторки за 30 миллисекунд наполняются воздухом. По заключению Страхового института дорожной безопасности (США) они являются одними из самых действенных средств защиты."
      safetyIcon_5:
        title: "Антипробуксовочная система"
        description: "Антипробуксовочная система исключает вероятность пробуксовки. При низкой скорости движения (до 80 км/ч) — передача крутящего момента не прекращается за счет подтормаживания ведущих колес; если скорость выше, колеса не буксуют за счёт уменьшения крутящего момента."
      safetyIcon_6:
        title: "BAS"
        description: "Система экстренного торможения (BAS) сокращает тормозной путь на 15–20 % процентов. Этого  иногда достаточно, чтобы избежать серьезной аварии. Система BAS по скорости, с которой водитель жмет на педаль тормоза, определяет, создалась ли на дороге ситуация экстренного торможения."
      safetyIcon_7:
        title: "ESC"
        description: "Система курсовой устойчивости (ESC) контролирует скорость и направление движения: сравнивает параметры датчиков с действиями водителя и отрабатывает потерю тяги автомобиля. Если ESC обнаруживает потерю управления, то передает индивидуальное тормозное усилие на каждое колесо."
      safetyIcon_8:
        title: "VSM"
        description: "Интегрированная система активного управления (VSM) – это тормозная система нового поколения, работающая в паре с ESC на безопасность движения. Незаменима в ситуациях, когда одна сторона автомобиля находится на мокрой или скользкой поверхности и теряет сцепление с дорогой."
      safetyIcon_9:
        title: "ESS"
        description: "Система предупреждения об экстренном торможении (ESS) автоматически информирует водителей, следующих за вами, о внезапном торможении — аварийные фонари начинают часто мигать."
    }
  }

  objects: {}

  constructor: () ->
    @objects.list = $('#safetyList')
    @objects.description = $('#safetyDescription')
    @list()
    @events()
    @first()

  list: () ->
    for alias, item of @data.items
      tmpLi = $('<li />')

      link = $('<a />')
      .attr 'href', "##{alias}"
      .addClass 'safetyLink'
      .attr 'title', item.title
      .appendTo tmpLi

      icon = $('<i />')
      .addClass "safetyIcon #{alias}"
      .appendTo link

      tmpLi.appendTo @objects.list

    return

  events: () ->
    $(document).on 'click', '.safetyLink', (event) =>
      event.preventDefault()
      link = $(event.currentTarget)
      target = link.attr('href').replace '#', ''
      @show target

  first: () ->
    target = Object.keys(@data.items)[0]
    @show target

  show: (target) ->
    if not item = @data.items[target]
      return

    $(".safetyLink i").removeClass 'active'
    $(".safetyLink[href=##{target}] i").addClass 'active'

    @objects.description.fadeOut 'fast', () =>
      @objects.description.html @content item
      @objects.description.fadeIn 'fast'

  content: (item) ->
    content = $('<div />').addClass 'safetyItemContent'
    h4 = $('<h4 />')
    .text item.title
    .appendTo content

    text = $('<div />')
    .addClass 'safetyItemText'
    .text item.description
    .appendTo content

    return content

$ ->
  window.safety = new SafetyPage()