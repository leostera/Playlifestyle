class UserRouter extends Routerious

  routes:
    'tutorial'        : 'tutorial'
    'users/:username' : 'profile'

  # Profile view
  profile: (username) =>
    ss.rpc "Users.Auth.Status", (res) =>      
      #check the status
      #if authenticated then show profile plus toolbar
      #else just show the profile with limited options
      console.log res
      if res.status is yes
        if username isnt res.user.username
          @navigate "users/#{res.user.username}", true
        else
          @__prepareView('User/Profile', {model: res.user})
      else
        @__prepareView('Utils/Templater', { template: "generic-message", details: { title: "Access Denied", message: "You are not logged in." } })

    @

  # Tutorial View
  tutorial: =>
    @__prepareView("Utils/Templater", { template: "generic-message", details: { title: "Welcome to the tutorial", message: """This should be the tutorial.
      <br /><a href="/signout"> Sign out </a>
      <br /><a href="/"> Home </a>
      """} })

exports.init = ->
  new UserRouter()