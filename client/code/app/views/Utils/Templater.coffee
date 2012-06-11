class UserProfileView extends Backbone.View

  el: '#content'

  initialize: (@options) =>
    @template = ss.tmpl[options.template]

    @

  render: =>
    @$el.html @template.render @options.details
    @

  
exports.init = (options) ->
  new UserProfileView(options).render()