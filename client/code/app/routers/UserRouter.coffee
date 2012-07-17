class UserRouter extends Routerious

  viewState:
    "events":
      default: "today"

    "settings":
      default: "privay"

    "messages":
      default: "all"

    "profile":
      default: "me"

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
        @__defaultRoute()
        @__prepareNav()
        @__prepareUniqueView('User/Profile')
      else
        @navigate '', true

    @

  #Events view
  events: (e) =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__defaultRoute()
        @__prepareNav()
        @__prepareUniqueView('User/Events')
      else
        @navigate '', true

    @

  #Settings view
  settings: =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__defaultRoute()
        @__prepareNav()
        @__prepareUniqueView('User/Settings')
      else
        @navigate '', true

    @

  #Messages view
  messages: =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__defaultRoute()
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

  __defaultRoute: (last=yes) =>
    fragments = Backbone.history.fragment.split('/')
    if fragments[1] is undefined      
      if last and @viewState[fragments[0]].last
        route = @viewState[fragments[0]].last
      else
        route = @viewState[fragments[0]].default
      @navigate "#{fragments[0]}/#{route}", true

  setLast: (route, sub) =>
    @viewState[route].last = sub    

exports.init = ->
  new UserRouter()