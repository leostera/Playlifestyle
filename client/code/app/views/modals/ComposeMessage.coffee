class ComposeMessageModal extends Backbone.View

  model: require("../../models/MessageModel").model

  template:
    outer: ss.tmpl['partials-message']
    inner: ss.tmpl['partials-message-compose']

  initialize: (options) =>
    @render().$el.modal(options?.modal)

    @

  render: =>
    @$el.hide()
    @$el.html @template.outer.render {}
    @$('.modal-body').html @template.inner.render {}    

    @

  show: =>
    @$el.modal('show')

  hide: =>
    @$el.modal('hide')

  send: (e) =>
    e.preventDefault()
    #get the RPC to send the message

  events:
    'click #send': "send"
  
exports.init = (options) ->
  new ComposeMessageModal(options)