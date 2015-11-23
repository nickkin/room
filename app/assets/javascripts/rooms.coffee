window.initMap = ->

  ymaps.ready ->
    myMap = new (ymaps.Map)('advertising-map', {
      center: [
        55.751574
        37.573856
      ]
      zoom: 10
      controls: []
    }, searchControlProvider: 'yandex#search')

    BalloonContentLayout = ymaps.templateLayoutFactory.createClass(
      '<div class="row">' +
        '<div class="col-sm-3">' +
          '<img src="{{properties.image_url}}"/>' +
        '</div>' +
        '<div class="col-sm-9">' +
          '<b>{{properties.name}}</b> <br/>Цена {{properties.price}}' +
        '</div>' +
      '</div>'
      )

    LoadingObjectManager = new (ymaps.LoadingObjectManager)(generateUrlToServer(true),
      clusterize: true
      clusterHasBalloon: false
      geoObjectOpenBalloonOnClick: false
      paddingTemplate: 'set_ads_to_map')

    window.LoadingObjectManager = LoadingObjectManager
    window.myMap = myMap

    LoadingObjectManager.objects.options.set {
      iconLayout: 'default#image',
      iconImageHref: '/assets/home.png',
      iconImageSize: [
        32
        32
      ],
      balloonContentLayout: BalloonContentLayout
    }

    LoadingObjectManager.objects.events.add 'click', (e)->
      objectId = e.get('objectId')

      LoadingObjectManager.objects.balloon.open(objectId);

    myMap.geoObjects.add(LoadingObjectManager)

    updateAdsList()

    myMap.events.add 'boundschange', (event)->
      if (event.get('newZoom') != event.get('oldZoom')) || (event.get('oldCenter') != event.get('newCenter'))
        updateAdsList()

window.initSlider = ->
  $("#js-filer-price").slider({value: [Number(localStorage.getItem("min_price")), Number(localStorage.getItem("max_price"))]})
  $("#js-filer-price").on "slideStop", (slideEvt)->
    localStorage.setItem("min_price", slideEvt.value[0])
    localStorage.setItem("max_price", slideEvt.value[1])

    LoadingObjectManager.setUrlTemplate(generateUrlToServer(true));
    LoadingObjectManager.reloadData()

    updateAdsList()

window.initOpenObjectBalloon = ->
  $('.js-advertising-item').on 'click', (e)->
    objectId = $(this).data("object-id")
    LoadingObjectManager.objects.balloon.open(objectId)

generateUrlToServer = (formYandexMap = false)->
  if formYandexMap
    url = '/advertisings?from=yandex_map&bbox=%b'
  else
    url = '/advertisings?bbox=' + myMap.getBounds().toString()

  if localStorage.getItem("min_price") && localStorage.getItem("max_price")
    newParam = {
      min_price: localStorage.getItem("min_price"),
      max_price: localStorage.getItem("max_price")
    }
    url += '&' + $.param(newParam)

  url

updateAdsList = ->
  $.get(generateUrlToServer())

