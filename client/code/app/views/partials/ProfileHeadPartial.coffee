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

  lookupOnEnter: (e) =>
    if e.keyCode is 13
      e.preventDefault()
      window.MainRouter.navigate "/search/#{@$('input.search-query').val()}", true

  events:
    "click a" : "silentlyRoute"
    "keypress input.search-query" : "lookupOnEnter"
  
exports.init = (options) ->
  new ProfileHeadPartial(options)