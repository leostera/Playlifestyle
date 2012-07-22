class UserProfileView extends Backbone.View

  initialize: (@options) =>
    @template = ss.tmpl[options.template]
    @$el = $ options.el
    console.log @template

    @

  render: =>
    @$el.html @template.render @options.details || { }
    @

  
exports.init = (options) ->
  new UserProfileView(options).render()