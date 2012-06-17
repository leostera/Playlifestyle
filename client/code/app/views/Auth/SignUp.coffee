class SignUpView extends Backbone.View

  model: require('../../models/Account').model

  template: ss.tmpl['signup-modal']

  el: "#modals"

  initialize: =>
    @user = new @model

  render: =>
    unless @$el.children('#signup').length isnt 0
      @$el.append @template.render {}
    @$('#signup').modal().show()
    
exports.init = () ->
  new SignUpView().render()