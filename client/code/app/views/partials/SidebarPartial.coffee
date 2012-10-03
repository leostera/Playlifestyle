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
    @$('.friends-list#follows h3').html("#{_.size(@user.following)} Following | #{_.size(@user.followers)} Followers")

    @

  silentlyRoute: (e) =>
    e.preventDefault()
    element = @$(e.srcElement)
    if e.srcElement.nodeName is "IMG"
      element = element.parent()
    fragment = element.attr('href')
    if fragment isnt "#hide-sidebar"
      console.log fragment
      window.MainRouter.navigate fragment, true

  events:
    "click a" : "silentlyRoute"
    
exports.init = (options={}) ->
  new SidebarPartial(options)