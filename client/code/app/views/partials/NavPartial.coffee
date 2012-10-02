class NavPartial extends Backbone.View

  template: ss.tmpl['nav']

  initialize: =>
    @$el = $('nav')
    @render()
    
  render: =>
    @$el.html @template.render {}    
    @

  silentlyRoute: (e) =>
    e.preventDefault()
    window.MainRouter.navigate @$(e.srcElement).attr("href"), true

  events:
    "click li a" : "silentlyRoute"
  
exports.init = (options) ->
  new NavPartial(options)