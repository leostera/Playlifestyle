class ProfileByUsernamePartial extends Backbone.View

  template: ss.tmpl['profile-by-username']

  initialize: (options) =>
    # Get the username from the parameters
    @username = options.username    
    # Initialize the user object
    @user = {}
    # Get the view element from the parameters
    @$el = $(options.el)
    # Hide it
    @$el.hide()

    @startFollowing = @startUnfollowing = false

    # Make an RPC to get the user information
    ss.rpc('Users.Account.GetUser', {username: @username}, (res) =>
      # If the result status is true
      if res.status is yes
        # Save the result user
        @user = res.user
        # And render the view
        console.log @user
        @render()

        # Then show the view
        @$el.fadeIn('fast') 

      else #otherwise
        # Show message
        alert('User not found! Going back to home...')
        # And go back home
        window.MainRouter.navigate '/home', true
    )

  render: =>
    # Render the template with the user
    @$el.html @template.render {user: @user}

    if @user is {}
      alert("Crap! User is gone!")
    if window.MainRouter.User.username is @user.username
      @$('button#follow').remove()

    # Try to find the user within the following list
    findIt = (f) => f.username is @user.username
    found = _.find window.MainRouter.User.following, findIt

    # Manage unfollowing behaviour
    if found
      @$('button#follow').addClass('hide')
      @$('button#unfollow').removeClass('hide').hover( (e) =>
          @$('button#unfollow').html('Unfollow').removeClass('disabled').addClass('btn-warning')
        , (e) =>
          @$('button#unfollow').html('Following').addClass('disabled').removeClass('btn-warning')
      )

    # Manage Social profile-tab behaviour
    if _.isEmpty @user.following
      @$('#put-follows-here').append("Apparently you don't like people.")
    else
      _.each @user.following, (f) =>
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('#put-follows-here').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )
        

    if _.isEmpty @user.followers
      @$('#put-followers-here').append("People doesn't like you.")
    else
      _.each @user.followers, (f) =>
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('#put-followers-here').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )    
    # Return itself      
    @

  follow: (e)=>
    e.preventDefault()
    ss.rpc("Users.Account.Follow", @user, (res) =>
      console.log @user, window.MainRouter.User, res
      if res.status is yes
        @user = res.followee
        window.MainRouter.User = res.user
        alert("Great, you are now following #{@username}!")
        @render()
    )

  unfollow: (e) =>
    e.preventDefault()
    if @startUnfollowing is false
      ss.rpc("Users.Account.Unfollow", @user, (res) =>
        console.log res
        if res.status is yes
          @user = res.followee
          window.MainRouter.User = res.user
          alert("How sad, you stopped following #{@username}!")
          @render()
          @startUnfollowing = true
        else
          @startUnfollowing = false
      )

  rerouteToUser: (e) =>
    e.preventDefault()
    console.log @$(e.srcElement).attr('href')
    window.MainRouter.navigate @$(e.srcElement).attr('href'), true

  events:
    'click button#follow' : "follow"
    'click button#unfollow' : "unfollow"
    'click ul.follows li a' : 'rerouteToUser'
    
exports.init = (options={}) ->
  new ProfileByUsernamePartial(options)