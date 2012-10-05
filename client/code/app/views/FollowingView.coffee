class FollowingView extends Backbone.View

  template: ss.tmpl['views-list']

  initialize: (options) =>
    @$el = $(options.el)
    @render()
    @$el = @$('#main-content')

  render: =>
    @user = window.MainRouter.User
    @$el.html @template.render {title: "Following", user: @user}

    friends_following = []

    _.each( @user.followers, (a) =>
        _.each( @user.following, (b) =>
          if a.id is b.id
            friends_following.push b
        )
      )

    friends = _.uniq(
          friends_following,
          false,
          (a,b) =>
            a.id is b.id
      )

    if _.isEmpty @user.following
      @$('ul.follows').append("People doesn't like you.")
    else
      following = _.difference( @user.following, friends_following)

      if _.isEmpty following
        @$('ul.follows').append("All your following are friends.")      
      
      else
        _.each following, (f) =>
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