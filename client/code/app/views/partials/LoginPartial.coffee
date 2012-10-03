class LoginPartial extends Backbone.View

  template: ss.tmpl['login']

  initialize: =>
    @render()
    @$el.find('input#username').focus()

  begin: =>
    $('#index').addClass('limit')
    @$el.hide().removeClass('hide').fadeIn('fast').find('input#username').focus()

  render: =>
    @$el.html @template.render {}
    @

  onSubmit: (e) =>
    e.preventDefault()

    user = @$('#username').val()
    pass = @$('#password').val()

    if @checkEmpty() is yes
      return

    # call the server for a sign in
    ss.rpc 'Users.Auth.SignIn', {username: user, password: pass}, (res) =>
      if res.status is yes
        window.MainRouter.navigate("home", true)
      else
        @$('#fields').addClass('error')
        @$('#errors').addClass('error').html(res.error).show('fast')

  triggerRegister: (e) =>
    e.preventDefault()
    @$el.fadeOut "fast", () =>
      @$('#password').val('')
      @$('#username').val('')
      @trigger "registration:begin"

  checkEmpty: (e) =>
    user = @$('#username').val()
    pass = @$('#password').val()
    unless not /^(\s)*$/.test user and not /^(\s)*$/.test pass
      @$('#fields').addClass('error')
      @$('#errors').addClass('error').show('fast')      
      return yes
    else
      @$('#fields').removeClass('error')
      @$('#errors').hide('fast')
      return no    

  events:
    'click button#login' : "onSubmit"
    'click button#register' : "triggerRegister"
    'change input' : "checkEmpty"

exports.init = (options={}) ->
  new LoginPartial(options)