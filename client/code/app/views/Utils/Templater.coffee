class UserProfileView extends Backbone.View

  initialize: (@options) =>
    @template = ss.tmpl[options.template]

    @

  render: =>
    $('#main').html @template.render @options.details
    @

  
exports.init = (options) ->
  new UserProfileView(options).render()