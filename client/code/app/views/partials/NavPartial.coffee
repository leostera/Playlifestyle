class NavView extends Backbone.View

  template: ss.tmpl['nav']

  initialize: =>
    @$el = $('nav')
    if $('nav').html() == ""
      @$el.hide()
      @render()
      @$el.fadeIn('slow')
    
  render: =>
    @$el.html @template.render {user: window.MainRouter.User}    
    @

  clickMenu: (e) =>
    e.preventDefault()    
    el = @$(e.srcElement)
    if e.target.nodeName is "LI"
      el = @$(el).children('a')
    route = el.attr('href').split('/')[1]
    if route is "profile"
      window.MainRouter.navigate route, true
    else
      window.MainRouter.navigate route

  events:
    'click a': "clickMenu"
    'click li': "clickMenu"
  
exports.init = (options) ->
  new NavView(options)