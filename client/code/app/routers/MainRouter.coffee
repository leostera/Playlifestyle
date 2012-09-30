class MainRouter extends Routerious

  routes:
    ''       : 'index'
    'profile': 'profile'
    'logout' : 'logout'
    'users/:username' : 'profileByUsername'
    'messages/:id'  : 'messages'


  # Main route
  index: =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      # If the user is not logged in
      if res?.status is no
        # Let him login or register       
        @__prepareView('IndexView', {el: $('#page-content')})
      else
        # Otherwise let's go to the home view
        @User = res.user
        @navigate 'profile'
        @__prepareView('ProfileView', {el: $('#page-content')})
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
        @__prepareView('IndexView', {el: $('#page-content')})
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('ProfileView', {el: $('#page-content')})
        @__prepareView('partials/NavPartial')
    )

  # Profile by Username route
  profileByUsername: (username) =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      if res?.status is no
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
      else
        @User = res.user
        @__prepareView('ProfileView', {el: $('#page-content'), username: usernam})
        @__prepareView('partials/NavPartial')
      )

  # Sign Out Route
  logout: =>
    ss.rpc("Users.Auth.SignOut", (res) =>
      if res.status is yes
        $('#page-content').attr('home',false)
        @navigate '', true
      else
        alert "Couldn't log you out buddy. Try again!"
      )

  # Messages route
  messages: (id) =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      if res?.status is no
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
      else
        @User = res.user
        @__prepareView('MessagesView', {el: '#page-content'})
        @__prepareView('partials/NavPartial')
    )

exports.init = (options={})->
  new MainRouter(options)
