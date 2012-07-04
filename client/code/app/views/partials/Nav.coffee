class NavView extends Backbone.View

  template: ss.tmpl['user-nav']

  render: =>
    $('nav').html @template.render {}
    $('header').html('')
    @

  
exports.init = (options) ->
  new NavView(options).render()