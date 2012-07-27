class HomeView extends Backbone.View

  template: ss.tmpl['home']

  initialize: =>
    if @$el.attr('home') isnt 'true'
      @$el.hide()
      @render()
      @$el.fadeIn('slow')
      @$el.attr('home','true')

  render: =>
    @$el.html @template.render {}
    @
    
exports.init = (options={}) ->
  new HomeView(options)