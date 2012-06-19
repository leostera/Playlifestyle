class UserProfileView extends Backbone.View

  templates:
    head: ss.tmpl['user-head']
    nav: ss.tmpl['user-nav']
    main: ss.tmpl['user-content-main']
    side: ss.tmpl['user-content-side']

  render: =>
    $('#nav').html @templates.nav.render { user: @model }
    $('#head').html @templates.head.render { user: @model }
    $('#main').html @templates.main.render { user: @model }
    $('#side').html @templates.side.render { user: @model }
    @

  
exports.init = (options) ->
  new UserProfileView(options).render()