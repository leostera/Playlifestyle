class SidebarPartial extends Backbone.View

  template: ss.tmpl['sidebar']

  initialize: =>
    @$el = $('#sidebar')
    @render()

  render: =>
    @user = window.MainRouter.User

    if @user.name is undefined
      @user.name = { }
      @user.name.first = "Go to profile"

    @$el.html @template.render { user: @user }

    unless _.isEmpty @user.following or _.isEmpty @user.followers
      friends = _.uniq(
          _.union( window.MainRouter.User.following, window.MainRouter.User.followers),
            false, #unordered list
            (a,b) ->
              a.id is b.id
        );
      @$('.friends-list#friends h3').html("#{_.size(friends)} Friends")
      @$('.friends-list#friends span').html("")

      _.each friends, (f) =>
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
          if res.status is yes
            @$('.friends-list#friends span').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )

    # Manage Social profile-tab behaviour
    unless _.isEmpty @user.following
      @$('.friends-list#i-follow h3').html("#{_.size(@user.following)} Following")
        
        
    unless _.isEmpty @user.followers
      @$('.friends-list#follow-me h3').html("#{_.size(@user.followers)} Followers")

    @

  silentlyRoute: (e) =>
    e.preventDefault()
    fragment = @$(e.srcElement).attr("href")
    if fragment isnt "#hide-sidebar"
      window.MainRouter.navigate fragment, true

  events:
    "click a" : "silentlyRoute"
    
exports.init = (options={}) ->
  new SidebarPartial(options)