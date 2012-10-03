class IndexView extends Backbone.View

  template: ss.tmpl['home']

  initialize: =>
    @render()

  render: =>    
    @$el.html @template.render {}
    
    @
    
exports.init = (options={}) ->
  new IndexView(options)