# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initSearchAddress = ->
  parentEntities = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('display_name')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    identify: (obj) ->
      obj.display_name
    remote:
      url: 'http://nominatim.openstreetmap.org/search?format=json&q=%QUERY'
      wildcard: '%QUERY')

  parentEntitiesDefaults = (q, sync) ->
    if q == ''
      sync parentEntities
    else
      parentEntities.search q, sync
    return

  $("#advertising_address").typeahead {
    minLength: 0
    highlight: true
  },
    name: 'parent_entities'
    display: 'display_name'
    source: parentEntities

  $("#advertising_address").bind 'typeahead:select', (ev, suggestion) ->
    $('[name="advertising[location]"]').val suggestion.lat + ' ' + suggestion.lon
    return