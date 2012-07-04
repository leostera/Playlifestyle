class UserProfileView extends Backbone.View

  templates:
    nav: ss.tmpl['user-nav']

  render: =>
    $('#navbar').html @templates.nav.render { user: @model }
    $('#header').html('')
    $('#body').html('')# @templates.main.render { user: @model }
    @

  
exports.init = (options) ->
  new UserProfileView(options).render()