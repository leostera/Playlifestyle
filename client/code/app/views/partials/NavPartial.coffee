class NavPartial extends Backbone.View

  template: ss.tmpl['nav']

  initialize: =>
    @$el = $('nav')
    @render()
    
  render: =>
    @$el.html @template.render {}    
    @
  
exports.init = (options) ->
  new NavPartial(options)