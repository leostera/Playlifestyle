class UserRouter extends Routerious

  routes:
    'users/:username' : 'profile'

  index: =>
    @__preparePage()
    @

  # Profile view
  profile: (username) =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__preparePage()
        if username isnt res.user.username
          @navigate "users/#{res.user.username}"
        else
          @__prepareView('User/Profile', {model: res.user})
      else
        @navigate '', true

    @

  __preparePage: =>
    @__prepareView('partials/Nav',{kill_all: no})
    @__prepareView('partials/Body',{kill_all: no})

exports.init = ->
  new UserRouter()