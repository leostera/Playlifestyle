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
    window.MainRouter.navigate route, true
  
  go2profile: (e) =>    
    if e.keyCode is 13
      e.preventDefault()
      s = @$('input[type="search"]').val()
      if s is "lea" or s is "jcarter"
        window.MainRouter.navigate "/users/#{s}", true

  events:
    'click a': "clickMenu"
    'click li': "clickMenu"
    'keydown input[type="search"]': "go2profile"
  
exports.init = (options) ->
  new NavView(options)