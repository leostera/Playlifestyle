class ProfileHeadPartial extends Backbone.View

  template: ss.tmpl['header']

  initialize: =>
    @$el = $('header')
    @render()
    
  render: =>
    @$el.html @template.render {}    
    @

  silentlyRoute: (e) =>
    e.preventDefault()
    fragment = @$(e.srcElement).attr("href")
    if fragment isnt "#"
      window.MainRouter.navigate fragment, true

  events:
    "click a" : "silentlyRoute"
  
exports.init = (options) ->
  new ProfileHeadPartial(options)