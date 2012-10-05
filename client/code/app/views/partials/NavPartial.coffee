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
    element = @$(e.srcElement)
    if e.srcElement.nodeName is "IMG"
      element = element.parent()
    fragment = element.attr('href')
    if fragment is "nightlife" or fragment is "home"
      window.MainRouter.navigate fragment, true


  events:
    "click li a" : "silentlyRoute"
  
exports.init = (options) ->
  new NavPartial(options)