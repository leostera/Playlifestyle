class PlaceholderView extends Backbone.View

  template: ss.tmpl['placeholder']

  initialize: =>
    @render()

  render: =>    
    @$el.html @template.render { title: Backbone.history.fragment.toString().toUpperCase() }

    @
    
exports.init = (options={}) ->
  new PlaceholderView(options)