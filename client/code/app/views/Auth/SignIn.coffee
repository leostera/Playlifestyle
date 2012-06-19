class SignInView extends Backbone.View

  template: ss.tmpl['signin-base']
  
exports.init = (options) ->
  new SignUpView().initialize(options).render()