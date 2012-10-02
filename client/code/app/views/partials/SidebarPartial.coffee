class SidebarPartial extends Backbone.View

  template: ss.tmpl['sidebar']

  initialize: =>
    @$el = $('#sidebar')
    @render()

  render: =>    
    @$el.html @template.render { user: window.MainRouter.User }
    
    @

  silentlyRoute: (e) =>
    e.preventDefault()
    fragment = @$(e.srcElement).attr("href")
    if fragment isnt "#"
      window.MainRouter.navigate fragment, true

  events:
    "click a" : "silentlyRoute"
    
exports.init = (options={}) ->
  new SidebarPartial(options)