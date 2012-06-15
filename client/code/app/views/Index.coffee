class IndexView extends Backbone.View

  template: ss.tmpl['index']

  el: '#content'

  initialize: =>
    ss.rpc "Users.Auth.Status", (res) ->
      if res.status is yes
        window.MainRouter.navigate "#{res.user.name}", true
      else if res.status is no and res.step is 1
        window.MainRouter.navigate "signup", true
      else
        console.log "Not logged in yet."
    @

  render: =>
    #render main template
    @$el.html @template.render {}

    #get the register form
    @registerView = require('./Auth/Registration').init("#sign-up-form")
    #bind to success
    @registerView.bind "registration:success", @redirectToGeoloc
    #render it!
    @registerView.render()

    @

  redirectToGeoloc: =>
    MainRouter.navigate("signup", true)

  onSubmit: (e) =>
    e.preventDefault()

    # VALIDATE user and password
    # show ticks or errors accordingly
    user = @$('form#login #user').val()
    pass = @$('form#login #pass').val()

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
        window.MainRouter.navigate("signin", true)        

  events:
    'click #signin' : "onSubmit"  

exports.init = ->
  new IndexView().initialize().render()
