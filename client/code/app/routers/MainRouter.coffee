class MainRouter extends Backbone.Router

  routes:
    ''            : 'index'
    'welcome'     : 'index'
    'signup'      : 'signup'
    'signin'      : 'signin'
    'signout'     : 'signout'
    'tutorial'    : 'tutorial'
    ':username'   : 'profile'

  initialize: =>
    @views       = []
    @models      = []
    @controllers = []

    @

  # Main route
  index: =>
    @__prepareView('Index')

    @

  # Login view
  signin: =>
    @__prepareView('Sign/SignIn')
    @

  signout: =>
    # do the logout
    # , (res) => )
    ss.rpc( "Users.Auth.SignOut", (res) =>
      if res is yes
        @navigate("welcome",true)
      else
        @__prepareView('Utils/Templater', { template: "generic-message", details: { title: "Holy Crap!", message: "We were unable to log you out. Try again please!" } })
    )

    @

  # Profile view
  profile: (username) =>
    ss.rpc "Users.Auth.Status", (res) =>
      #check the status
      #if authenticated then show profile plus toolbar
      #else just show the profile with limited options
      if res.status is yes
        @__prepareView('User/Profile', username)
      else
        @__prepareView('Utils/Templater', { template: "generic-message", details: { title: "Access Denied", message: "You are not logged in." } })

    @

  # Registration view
  signup: =>
    ss.rpc "Users.Auth.Status", (res) =>
      if res.status is no
        @__prepareView("Sign/SignUp",{ el:"#content", step: res.step} )
      else
        @__prepareView("Utils/Templater", { template: "generic-message", details: { title: "Can't Login Again", message: "You are already logged in."} })

    @

  # Tutorial View
  tutorial: =>
    @__prepareView("Utils/Templater", { template: "generic-message", details: { title: "Welcome to the tutorial", message: """This should be the tutorial.
      <br /><a href="/signout"> Sign out </a>
      <br /><a href="/"> Home </a>
      """} })


  ###
  Utility functions
  ###

  # __prepareView( view )
  __prepareView: (view, options=undefined, killMe=yes) =>
    @__killViews()
    @views.push require('../views/'+view).init(options)
    @views.getLast().killMe = killMe
    @views.getLast()

  # __killViews
  ## Takes care of removing all the views and unbinding all events
  ## when rerouting to a new path
  __killViews: (options={preserve_dom: true}) =>
    _.forEach @views, (view) =>
      if view.killMe is yes
        view.kill(options)
        view.killMe = no
      @views.pop view

exports.init = ->
  new MainRouter()