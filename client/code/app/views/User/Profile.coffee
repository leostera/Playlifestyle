class UserProfileView extends Backbone.View

  template: ss.tmpl['user-main']

  initialize: =>
    @$el = $('#body')

  render: =>
    #@$el.html @template.render { user: @model }
    @$el.html "This is the profile tab."
    @

  messageMe: (e) =>
    e.preventDefault()

  events:
    'click #message-me': 'messageMe'
  
exports.init = (options) ->
  new UserProfileView(options).render()