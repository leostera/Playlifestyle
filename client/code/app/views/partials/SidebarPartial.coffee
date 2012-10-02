class SidebarPartial extends Backbone.View

  template: ss.tmpl['sidebar']

  initialize: =>
    @$el = $('#sidebar')
    @render()

  render: =>
    @user = window.MainRouter.User
    @$el.html @template.render { user: @user }

    # Manage Social profile-tab behaviour
    unless _.isEmpty @user.following
      @$('.friends-list#i-follow span').html('')
      _.each @user.following, (f) =>
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('.friends-list#i-follow span').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )
        
    unless _.isEmpty @user.followers
      @$('.friends-list#follow-me span').html('')
      _.each @user.followers, (f) =>
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('.friends-list#follow-me span').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )   

    @

  silentlyRoute: (e) =>
    e.preventDefault()
    fragment = @$(e.srcElement).attr("href")
    if fragment isnt "#"
      window.MainRouter.navigate fragment, true

  events:
    "click a" : "silentlyRoute"
    
exports.init = (options={}) ->
  new SidebarPartial(options)