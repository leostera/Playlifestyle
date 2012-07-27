class MainRouter extends Routerious

  routes:
    ''      : 'index'
    'home'  : 'home'
    'logout': 'logout'

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
        @navigate 'home', true
    )

  # Home route
  home: =>
    @__prepareView('HomeView', {el: $('#body')})
    @__prepareView('partials/NavPartial')

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