class ProfileView extends Backbone.View

  template: ss.tmpl['views-profile']

  initialize: (options) =>   
    # Initialize the user object
    @user = options.user
    # Get the view element from the parameters
    @$el = $(options.el)

    @startFollowing = @startUnfollowing = false

    @render()
    @$el = $('#main-content')

  render: =>
    # Render the template with the user
    @$el.html @template.render {user: @user}

    #@messageModal = require('../modals/ComposeMessage').init({el: ".modals", modal: 'hide'})
    
    if @user is {}
      alert("Crap! User is gone!")
    if window.MainRouter.User.username is @user.username
      @$('a#follow').remove()
      @$('a#message').remove()

    # Try to find the user within the following list
    findIt = (f) => f.username is @user.username
    found = _.find window.MainRouter.User.following, findIt

    # Manage unfollowing behaviour
    if found
      @$('a#follow').hide();
      @$('a#unfollow').show().hover( (e) =>
          @$('a#unfollow').html('Unfollow').removeClass('disabled').addClass('btn-warning')
        , (e) =>
          @$('a#unfollow').html('Following').addClass('disabled').removeClass('btn-warning')
      )
    else
      @$('a#unfollow').hide()
      @$('a#follow').show()

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

      _.each friends, (f) =>
        ss.rpc("users.account.get", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('#put-friends-here').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )

    following = _.difference( @user.following, friends_following)
    followers = _.difference( @user.followers, friends_followers)
          

    # Manage Social profile-tab behaviour
    if _.isEmpty @user.following
      @$('#put-following-here').append("Apparently you don't follow anybody.")
    else if _.isEmpty following
      @$('#put-following-here').append("All your following are friends.")
    else
      _.each following, (f) =>
        ss.rpc("users.account.get", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('#put-follows-here').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )

    if _.isEmpty @user.followers
      @$('#put-followers-here').append("People doesn't like you.")
    else if _.isEmpty followers
      @$('#put-followers-here').append("All your followers are friends.")
    else
      _.each followers, (f) =>
        ss.rpc("users.account.get", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('#put-followers-here').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )     
    # Return itself      
    @

  follow: (e)=>
    e.preventDefault()
    ss.rpc("users.account.follow", @user, (res) =>
      console.log @user, window.MainRouter.User, res
      if res.status is yes
        @user = res.followee
        window.MainRouter.User = res.user
        alert("Great, you are now following #{@user.username}!")
        Backbone.history.loadUrl(Backbone.history.fragment);
    )

  unfollow: (e) =>
    e.preventDefault()
    if @startUnfollowing is false
      ss.rpc("users.account.unfollow", @user, (res) =>
        console.log res
        if res.status is yes
          @user = res.followee
          window.MainRouter.User = res.user
          alert("How sad, you stopped following #{@user.username}!")
          Backbone.history.loadUrl(Backbone.history.fragment);
          @startUnfollowing = true
        else
          @startUnfollowing = false
      )

  silentlyRoute: (e) =>
    e.preventDefault()
    element = @$(e.srcElement)
    if e.srcElement.nodeName is "IMG"
      element = element.parent()
    fragment = element.attr('href')
    if fragment isnt "#"
      console.log fragment
      window.MainRouter.navigate fragment, true
  compose: (e) =>
    e.preventDefault()
    @messageModal.show()

  events:
    'click a#follow' : "follow"
    'click a#unfollow' : "unfollow"
    'click ul.follows a' : 'silentlyRoute'
    'click a#message' : "compose"
    
exports.init = (options={}) ->
  new ProfileView(options)