class UserEventsView extends Backbone.View

  template: ss.tmpl['generic-tab']

  initialize: =>
    @$el = $('#body')

  render: =>
    @$el.html @template.render { }    
    @$('#message').html "This is the events tab."
    @$('#subsection').html "We are at the #{Backbone.history.fragment.split('/')[1]} subtab!"
    @

  messageMe: (e) =>
    e.preventDefault()

  events:
    'click #message-me': 'messageMe'
  
exports.init = (options) ->
  new UserEventsView(options).render()