class UserRouter extends Routerious

  routes:
    'events'        : 'events'

    'settings' : 'settings'

    'messages' : 'messages'

    'profile'    : 'profile'

  index: =>
    @events()

    @

  # Profile view
  profile: (username) =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__prepareNav()
        @__prepareUniqueView('User/Profile')
      else
        @navigate '', true

    @

  #Events view
  events: (e) =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__prepareNav()
        @__prepareUniqueView('User/Events')
      else
        @navigate '', true

    @

  #Settings view
  settings: =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__prepareNav()
        @__prepareUniqueView('User/Settings')
      else
        @navigate '', true

    @

  #Messages view
  messages: =>
    ss.rpc "Users.Auth.Status", (res) =>  

      if res.status is yes
        @__prepareNav()
        @__prepareUniqueView('User/Messages')
      else
        @navigate '', true

    @

  __prepareNav: =>
    @__killViews()
    @__prepareUniqueView('partials/Nav')
    @views[0].setActive(Backbone.history.fragment || 'events')
    

exports.init = ->
  new UserRouter()