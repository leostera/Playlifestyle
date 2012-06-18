class MainRouter extends Backbone.Router

  routes:
    ''             : 'index'
    'p/:partial/:element'  : 'dummy'
    'signup'       : 'signup'
    'signup/:step' : 'signup'
    'signout'     : 'signout'
    #'tutorial'    : 'tutorial'
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

  # Registration route that triggers registration process on the Index view
  signup: () =>
    @__prepareView("Index").register()

    @

  # Login view
  signin: =>
    @__prepareView('Auth/SignIn')
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

  # Tutorial View
  tutorial: =>
    @__prepareView("Utils/Templater", { template: "generic-message", details: { title: "Welcome to the tutorial", message: """This should be the tutorial.
      <br /><a href="/signout"> Sign out </a>
      <br /><a href="/"> Home </a>
      """} })

  dummy: (partial,element) =>
    view = @__prepareView("Auth/partials/#{partial}")
    console.log view
    $("##{element}").html view.render()

  ###
  Utility functions
  ###

  # __prepareView( view )
  __prepareView: (view, options=undefined, killMe=yes) =>
    @__killViews()
    view = require('../views/'+view).init(options)
    view.killMe = killMe
    @views.push view
    _.last @views

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