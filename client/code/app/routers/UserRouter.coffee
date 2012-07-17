class UserRouter extends Routerious

  routes:
    'events'        : 'events'
    'events/:subsection'        : 'events'

    'settings' : 'settings'
    'settings/:subsection' : 'settings'

    'messages' : 'messages'
    'messages/:subsection' : 'messages'

    'profile'    : 'profile'
    'profile/:subsection'    : 'profile'

  index: =>
    @events()

    @

  # Profile view
  profile: (username) =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__defaultRoute 'me'
        @__prepareNav()
        @__prepareUniqueView('User/Profile')
      else
        @navigate '', true

    @

  #Events view
  events: (e) =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__defaultRoute 'today'
        @__prepareNav()
        @__prepareUniqueView('User/Events')
      else
        @navigate '', true

    @

  #Settings view
  settings: =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__defaultRoute 'privacy'
        @__prepareNav()
        @__prepareUniqueView('User/Settings')
      else
        @navigate '', true

    @

  #Messages view
  messages: =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__defaultRoute 'all'
        @__prepareNav()
        @__prepareUniqueView('User/Messages')
      else
        @navigate '', true

    @

  __prepareNav: =>
    @__killViews()
    @__prepareUniqueView('partials/Nav')
    route = Backbone.history.fragment.split('/')[0] || Backbone.history.fragment
    subroute = Backbone.history.fragment.split('/')[1]
    @views[0].setActive( route || 'events', subroute || '')

  __defaultRoute: (route) =>
    fragments = Backbone.history.fragment.split('/')
    if fragments[1] is undefined
      @navigate "#{fragments[0]}/#{route}", true


    

exports.init = ->
  new UserRouter()