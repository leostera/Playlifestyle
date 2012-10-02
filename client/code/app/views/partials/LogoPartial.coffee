class LogoPartial extends Backbone.View

  template: ss.tmpl['logo']

  initialize: =>
    $('nav').html('')
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
    "click li a" : "silentlyRoute"
  
exports.init = (options) ->
  new LogoPartial(options)