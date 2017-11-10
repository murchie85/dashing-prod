class Dashing.Stock extends Dashing.Widget
  @accessor 'price', Dashing.AnimatedValue

  @accessor 'changepercent', ->
    @get('change')[1..-1] + ' (' + @get('percentchange')[1..-1] + ')'
  
  @accessor 'title', ->
    @get('name') + ' (' +@get('symbol') + ')'
  
  @accessor 'lasttrade', ->
    'Last traded at ' + @get('lasttradetime')
  
  @accessor 'arrow', ->
    if parseFloat(@get('change')) > 0 then 'icon-arrow-up' else 'icon-arrow-down'

