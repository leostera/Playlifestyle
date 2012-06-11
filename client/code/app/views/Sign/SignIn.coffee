class SignInView extends Backbone.View

  template: ss.tmpl['forms-sign-in']

  initialize: (el) =>
    @$el = $ el
    @

  render: =>
    @$el.html @template.render {}
    @

  onSubmit: (e) =>
    e.preventDefault()

    # VALIDATE user and password
    # show ticks or errors accordingly
    user = @$('#user').val()
    pass = @$('#pass').val()

    # call the server for a sign in
    ss.rpc 'Users.Auth.SignIn', {email: user, pass: pass}, (res) ->
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

exports.init = (el = "#content") ->
  new SignInView().initialize(el).render()