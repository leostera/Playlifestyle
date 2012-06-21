class UserRouter extends Routerious

  routes:
    'tutorial'        : 'tutorial'
    'tutorial/'       : 'tutorial'
    'tutorial/:step'  : 'tutorial'
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
    @navigate 'tutorial/begin'
    ss.rpc "Users.Auth.Status", (res) =>
      console.log res

      if res.status is yes
        @__prepareView('User/Tutorial')
      else
        @__prepareView("Utils/Templater", { template: "generic-message", details: { title: "Welcome to the tutorial", message: """Unfortunately you are not logged in to enjoy it.
        <br /><a href="/signup"> Don't have an account? Sign up now! </a>
        <br /><a href="/"> Back to the home page </a>
        """} })

exports.init = ->
  new UserRouter()