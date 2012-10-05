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

      friends_following = friends_followers = []

      _.each( @user.following, (a) =>
          _.each( @user.followers, (b) =>
            if a.id is b.id
              friends_following.push a
              friends_followers.push b
          )
        )

      friends = _.uniq(
            friends_following,
            false,
            (a,b) =>
              a.id is b.id
        )

      @$('.friends-list#friends h3 a').html("#{_.size(friends)} Friends")
      @$('.friends-list#friends span').html("")

      _.each friends, (f) =>
        ss.rpc("users.account.get", {username: f.username}, (res) =>
          if res.status is yes
            @$('.friends-list#friends span').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )

    following = _.difference( @user.following, friends_following)
    followers = _.difference( @user.followers, friends_followers)

    # Manage Social profile-tab behaviour
    @$('.friends-list#follows h3 a#following').html("#{_.size(following)} Following")
    @$('.friends-list#follows h3 a#followers').html("#{_.size(followers)} Followers")

    if $('.navbar').css('position') is 'fixed' and $('.sidebar-content').css('height') isnt '0' and Backbone.history.fragment isnt 'profile'
      $('.sidebar-content').collapse('hide')
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