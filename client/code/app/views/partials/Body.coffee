class BodyView extends Backbone.View

  template: ss.tmpl['user-body']

  render: =>
    $('#body').html('')
    @

exports.init = (options) ->
  new BodyView(options).render()