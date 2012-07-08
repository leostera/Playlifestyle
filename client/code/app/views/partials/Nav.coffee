class NavView extends Backbone.View

  template: ss.tmpl['partials-nav']

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
    window.UserRouter.navigate route, true

  setActive: (routeName) =>
    @$("ul.nav#menu li.active").removeClass('active')
    @$("ul.nav#menu li a[href=\"/#{routeName}\"]").parent().addClass('active')

    @$("section.tab-pane.active").removeClass('active')
    @$("section.tab-pane##{routeName}").addClass('active')

  clickBrand: (e) =>
    e.preventDefault()
    window.UserRouter.navigate 'events', true

  events:
    "click ul.nav#menu li" : "clickMenu" 
    "click a.brand" : "clickBrand"

  
exports.init = (options) ->
  new NavView(options).render()