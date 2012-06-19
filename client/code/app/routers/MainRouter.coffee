class MainRouter extends Routerious

  routes:
    ''             : 'index'
    'signup'       : 'signup'
    'signup/:step' : 'signup'
    'signout'     : 'signout'

  # Main route
  index: =>
    @__prepareView('Index')

    @

  # Registration route that triggers registration process on the Index view
  signup: () =>
    @__prepareView("Index").register()

    @

  # Ask the server if the user can be logged out
  signout: =>
    ss.rpc( "Users.Auth.SignOut", (res) =>
      if res.status is yes
        @navigate("",true)
      else
        @__prepareView('Utils/Templater', { template: "generic-message", details: { title: "Holy Crap!", message: "We were unable to log you out. Try again please!" } })
    )

    @

exports.init = ->
  new MainRouter()