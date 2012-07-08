class UserRouter extends Routerious

  routes:
    'events'        : 'events'
    'events/:event' : 'events'

    'settings' : 'settings'

    'messages' : 'messages'

    'profile'    : 'profile'

  index: =>
    @__prepareNav()
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
    @__prepareNav()
    console.log "We are at the events"

  #Settings view
  settings: =>
    @__prepareNav()
    console.log "We are at the settings."

  #Messages view
  messages: =>
    @__prepareNav()
    console.log "We are at the Messages."

  __prepareNav: =>
    @__prepareUniqueView('partials/Nav')
    

exports.init = ->
  new UserRouter()