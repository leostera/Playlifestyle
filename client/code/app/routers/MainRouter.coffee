class MainRouter extends Routerious

  routes:
    ''       : 'index'
    "home"  : 'index'
    'profile': 'profile'
    'logout' : 'logout'
    'users/:username' : 'profileByUsername'
    'messages/:id'  : 'messages'
    
    #placeholder
    'active': 'placeholder'  
    'arts': 'placeholder'  
    'culinary': 'placeholder'  
    'fashion':  'placeholder'  
    'buzz': 'placeholder'  
    'music':  'placeholder'  
    'nightlife':  'placeholder'  
    'sports': 'placeholder'  
    'travel': 'placeholder'
    'settings': 'placeholder'
    'messages': 'placeholder'
    'notifications': 'placeholder'

  # Main route
  index: =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      # If the user is not logged in
      if res?.status is no
        # Let him login or register       
        @__prepareView('IndexView', {el: $('#page-content')})
        #clean the nav and the header
        $('nav').html('')
        $('header').html('')
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('HomeView', {el: $('#page-content')})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
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
        #clean the nav and the header
        $('nav').html('')
        $('header').html('')
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('ProfileView', {el: $('#page-content')})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

  # Profile by Username route
  profileByUsername: (username) =>
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      if res?.status is no
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        #clean the nav and the header
        $('nav').html('')
        $('header').html('')
      else
        @User = res.user
        @__prepareView('ProfileView', {el: $('#page-content'), username: usernam})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
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
        #clean the nav and the header
        $('nav').html('')
        $('header').html('')
      else
        @User = res.user
        @__prepareView('MessagesView', {el: '#page-content'})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

  # Placeholder
  placeholder: ->
    ss.rpc( "Users.Auth.Status", (res) =>
      console.log res
      if res?.status is no
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        #clean the nav and the header
        $('nav').html('')
        $('header').html('')
      else
        @User = res.user
        @__prepareView('PlaceholderView', {el: '#page-content'})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

exports.init = (options={})->
  new MainRouter(options)
