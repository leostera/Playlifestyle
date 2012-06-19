class LoginPartial extends Backbone.View

  template: ss.tmpl['signin-partials-login']

  className: "registration"

  prerender: =>
    @$el.html @template.render {}
    @

  render: =>
    @.el

  onSubmit: (e) =>
    e.preventDefault()

    user = @$('#username').val()
    pass = @$('#password').val()

    # call the server for a sign in
    ss.rpc 'Users.Auth.SignIn', {username: user, password: pass}, (res) ->
      console.log res
      if res.status is yes
        window.MainRouter.navigate("users/#{res.user.username}", true)        
      else
        @$('#error').html(res.error)

  events:
    'click #login' : "onSubmit"    

exports.init = -> new LoginPartial().prerender()