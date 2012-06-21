class LoginPartial extends Backbone.View

  template: ss.tmpl['signin-partials-login']

  prerender: =>
    @$el.html @template.render {}    
    if $('body').width() > 980
      @$('#signin').removeClass('form-horizontal')
    else
      @$('#signin').addClass('form-horizontal')
      @$('#signin').addClass("loginPartial")

    @

  render: =>
    @.el

  onSubmit: (e) =>
    e.preventDefault()

    user = @$('#username').val()
    pass = @$('#password').val()

    # call the server for a sign in
    ss.rpc 'Users.Auth.SignIn', {username: user, password: pass}, (res) =>
      if res.status is yes
        window.MainRouter.navigate("users/#{res.user.username}", true)        
      else
        @$('#username-cg').addClass('error')
        @$('#error-cg').addClass('error')
        @$('#password-cg').addClass('error')
        @$('#error').html(res.error)

  justPrevent: (e) =>
    e.preventDefault()
    @trigger 'registration:begin'

  events:
    'click #login' : "onSubmit"
    'click #register' : "justPrevent"


exports.init = -> new LoginPartial().prerender()