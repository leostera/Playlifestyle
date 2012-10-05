class MainRouter extends Routerious

  routes:
    ''       : 'index'
    "home"  : 'index'
    'profile': 'profile'
    'logout' : 'logout'
    'users/:username' : 'profileByUsername'
    'following': 'following'
    'followers': 'followers'
    'friends': 'friends'
    'search/:query' : 'search'

    #placeholder
    'messages/:id'  : 'placeholder'
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
    ss.rpc( "auth.status", (res) =>
      # If the user is not logged in
      if res?.status is no
        # Let him login or register       
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
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
    ss.rpc( "auth.status", (res) =>
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('ProfileEditView', {el: $('#page-content')})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

  following: =>
    ss.rpc( "auth.status", (res) =>
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('FollowingView', {el: $('#page-content')})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

  followers: =>
    ss.rpc( "auth.status", (res) =>
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('FollowersView', {el: $('#page-content')})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

  friends: =>
    ss.rpc( "auth.status", (res) =>
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('FriendsView', {el: $('#page-content')})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

  search: (query) =>
    ss.rpc( "auth.status", (res) =>
      # If the user is not logged in
      if res?.status is no
        # Let him login or register        
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        # Otherwise let's go to the home view
        @User = res.user
        @__prepareView('SearchView', {el: $('#page-content'), query: query})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )


  # Profile by Username route
  profileByUsername: (username) =>
    ss.rpc( "auth.status", (res) =>
      if res?.status is no
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        @User = res.user
        if username is res.user.username
          @navigate 'profile', true
        # Make an RPC to get the user information
        ss.rpc('users.account.get', {username: username}, (res2) =>
          # If the result status is true
          if res2.status is yes
            @__prepareView('ProfileView', {el: $('#page-content'), user: res2.user})
            @__prepareView('partials/ProfileHeadPartial')
            @__prepareView('partials/NavPartial')
            @__prepareView('partials/SidebarPartial')
          else #otherwise
            alert('User not found! Going back to home...')
            window.MainRouter.navigate '/home', true
        )
        
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
    ss.rpc( "auth.status", (res) =>
      if res?.status is no
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        @User = res.user
        @__prepareView('MessagesView', {el: '#page-content'})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

  # Placeholder
  placeholder: ->
    ss.rpc( "auth.status", (res) =>
      if res?.status is no
        @navigate ''
        @__prepareView('IndexView', {el: $('#page-content')})
        @__prepareView("partials/LogoPartial")
      else
        @User = res.user
        @__prepareView('PlaceholderView', {el: '#page-content'})
        @__prepareView('partials/SidebarPartial')
        @__prepareView('partials/ProfileHeadPartial')
        @__prepareView('partials/NavPartial')
    )

exports.init = (options={})->
  new MainRouter(options)
