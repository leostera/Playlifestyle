class UserProfileView extends Backbone.View

  el: '#full'

  initialize: (@options) =>
    @template = ss.tmpl[options.template]

    @

  render: =>
    @$('#side').hide()
    @$('#main').hide()
    @$el.html @template.render @options.details
    @

  
exports.init = (options) ->
  new UserProfileView(options).render()