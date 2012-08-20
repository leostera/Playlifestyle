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

    # Make an RPC to get the user information
    ss.rpc('Users.Account.ShowUser', {username: @username}, (res) =>
      # If the result status is true
      if res.status is yes
        # Save the result user
        @user = res.user
        # And render the view
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
      @$('button#follow').addClass('disabled').html('Following').hover( (e) =>
          @$('button#follow').html('Unfollow').removeClass('disabled').addClass('button-warning')
        , (e) =>
          @$('button#follow').html('Following').addClass('disabled').removeClass('button-warning')
      ).click @unfollow

    # Manage Social profile-tab behaviour
    if _.isEmpty @user.following
      @$('#put-follows-here').append("This guy doesn't like much people.")
    else
      _.each @user.following, (f) ->
        @$('#put-follows-here').append( ss.tmpl['partials-follow'].render { username: f.username } )

    if _.isEmpty @user.followers
      @$('#put-followers-here').append("People doesn't like this guy.")
    else
      _.each @user.followers, (f) ->
        @$('#put-followers-here').append( ss.tmpl['partials-follow'].render { username: f.username } )
    
    # Return itself      
    @

  follow: (e)=>
    e.preventDefault()
    if @$(e.srcElement).hasClass('disabled')
      return

    ss.rpc("Users.Account.Follow", @user, (res) =>
      if res.status is yes
        window.MainRouter.User = res.user
        alert("Great, you are now following #{@username}!")
        @$('button#follow').addClass('disabled').html('Following')
    )

  unfollow: (e) =>
    e.preventDefault()

    ss.rpc("Users.Account.Unfollow", @user, (res) =>
      if res.status is yes
        window.MainRouter.User = res.user
        alert("How sad, you stopped following #{@username}!")
        @$('button#follow').removeClass('disabled').html('Follow')
    )

  events:
    'click button#follow' : "follow"
    'click button#message': "render"
    'click button#invite' : "render"
    
exports.init = (options={}) ->
  new ProfileByUsernamePartial(options)