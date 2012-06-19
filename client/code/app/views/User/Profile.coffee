class UserProfileView extends Backbone.View

  templates:
    head: ss.tmpl['user-head']
    nav: ss.tmpl['user-nav']
    main: ss.tmpl['user-content-main']
    side: ss.tmpl['user-content-side']

  render: =>
    $('#nav').html @templates.nav.render {}
    $('#head').html @templates.head.render {}
    $('#main').html @templates.main.render {}
    $('#side').html @templates.side.render {}
    @

  
exports.init = () ->
  new UserProfileView().render()