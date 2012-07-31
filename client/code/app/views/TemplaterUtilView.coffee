class UserProfileView extends Backbone.View

  initialize: (@options) =>
    console.log options
    @template = ss.tmpl[options.template]
    @$el = $ options.el
    @$el.hide()
    @render()
    @$el.fadeIn('slow')

    @

  render: =>
    @$el.html @template.render @options.details || { }
    @

  
exports.init = (options) ->
  new UserProfileView(options)