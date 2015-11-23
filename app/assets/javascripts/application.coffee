# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks

#= require twitter/typeahead.min
#= require_tree .

#= require jquery
#= require bootstrap-sprockets

# rails assets
#= require seiyria-bootstrap-slider

window.initSearchAddress = ->
  parentEntities = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('display_name')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    identify: (obj) ->
      obj.display_name
    remote:
      url: 'https://nominatim.openstreetmap.org/search?format=json&q=%QUERY'
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