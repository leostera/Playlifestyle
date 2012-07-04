class UserProfileView extends Backbone.View

  template: sss.tmpl['user-main']

  render: =>
    $('#body').html @template.render { user: @model }
    @
  
exports.init = (options) ->
  new UserProfileView(options).render()