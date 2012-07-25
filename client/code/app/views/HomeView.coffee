class HomeView extends Backbone.View

  template: ss.tmpl['home']

  initialize: =>
    setTimeout () =>
        @$el.fadeOut('slow', () =>
          @render()
          @$el.fadeIn('slow')
        )
      , 100

  render: =>
    @$el.html @template.render {}
    @
    
exports.init = (options={}) ->
  new HomeView(options)