class _LoginPartial extends Backbone.View

  template: ss.tmpl['signin-partials-login']

  className: "registration"

  prerender: =>
    @$el.html @template.render {}
    @

  render: =>
    @.el

  onSubmit: (e) =>
    e.preventDefault()

    user = @$('#user').val()
    pass = @$('#pass').val()

    # call the server for a sign in
    ss.rpc 'Users.Auth.SignIn', {user: user, pass: pass}, (res) ->
      # if the server returns yes
      # then show hooray message and redirect to profile
      # else
      # the server returned an error message
      # show it
      if res.result is yes
        window.MainRouter.navigate(res.session.name, true)        
      else
        window.MainRouter.navigate("welcome", true)        

  events:
    'click #login' : "onSubmit"    

exports.init = -> new _LoginPartial().prerender()