class MainRouter extends Routerious

  routes:
    ''       : 'index'
    'home'   : 'home'
    'profile': 'profile'
    'logout' : 'logout'
    'users/:username' : 'showUser'

  # Main route
  index: =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @__prepareView('IndexView', {el: $('#body')})
      else
        # Otherwise let's go to the home view
        @User = res.user
        @navigate 'home'
        @__prepareView('HomeView', {el: $('#body')})
        @__prepareView('partials/NavPartial')
    )

  # Home route
  home: =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @navigate ''
        @__prepareView('IndexView', {el: $('#body')})
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('HomeView', {el: $('#body')})
        @__prepareView('partials/NavPartial')
    )

  # Profile route
  profile: =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @navigate ''
        @__prepareView('IndexView', {el: $('#body')})
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('HomeView', {el: '#body'})
        @__prepareView('partials/NavPartial')
        @__prepareView('partials/ProfilePartial', {el: '#right'})
    )

  # Sign Out Route
  logout: =>
    ss.rpc("Users.Auth.SignOut", (res) =>
      if res.status is yes
        @navigate '', true
      else
        alert "Couldn't log you out buddy. Try again!"
      )


exports.init = (options={})->
  new MainRouter(options)
