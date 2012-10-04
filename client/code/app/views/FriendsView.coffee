class FollowingView extends Backbone.View

  template: ss.tmpl['views-list']

  initialize: (options) =>
    @$el = $(options.el)
    @render()
    @$el = @$('#main-content')

  render: =>
    @user = window.MainRouter.User
    @$el.html @template.render {user: @user}

    if _.isEmpty @user.following or _.isEmpty @user.followers
      @$('ul.follows').append("You have no friends.")
    else
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
            @$('ul.follows').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        )

    @

  rerouteToUser: (e) =>
    e.preventDefault()
    window.MainRouter.navigate @$(e.srcElement).parent().attr('href'), true


  events:
    'click ul.follows li a img' : 'rerouteToUser'
    
exports.init = (options={}) ->
  new FollowingView(options)