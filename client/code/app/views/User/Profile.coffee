class UserProfileView extends Backbone.View

  template: ss.tmpl['generic-tab']

  initialize: =>
    @$el = $('#body')

  render: =>
    @$el.html @template.render { }
    @$('#message').html "This is the profile tab."
    @$('#subsection').html "We are at the #{Backbone.history.fragment.split('/')[1]} subtab!"
    @

  messageMe: (e) =>
    e.preventDefault()

  events:
    'click #message-me': 'messageMe'
  
exports.init = (options) ->
  new UserProfileView(options).render()