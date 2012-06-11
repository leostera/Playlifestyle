class UserProfileView extends Backbone.View

  template: ss.tmpl['user-profile']

  el: '#content'

  initialize: (@username) =>
    @

  render: =>
    @$el.html @template.render { user: @username }
    @

  
exports.init = (username) ->
  new UserProfileView(username).render()