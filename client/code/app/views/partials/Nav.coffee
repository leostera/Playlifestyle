class NavView extends Backbone.View

  template: ss.tmpl['user-nav']

  initialize: =>
    @$el = $('nav')

  render: =>
    @$el.html @template.render {}
    $('header').html('')
    @

  clickMenu: (e) =>
    e.preventDefault()    
    el = @$(e.srcElement)
    if e.srcElement.localName is 'i'
      el = el.parent()

    route = el.attr('href').split('/')[1]
    console.log route
    window.UserRouter.navigate route, true

  events:
    "click ul.nav#menu li" : "clickMenu"    

  
exports.init = (options) ->
  new NavView(options).render()