class FollowersView extends Backbone.View

  template: ss.tmpl['views-list']

  initialize: (options) =>
    @$el = $(options.el)
    @render()
    @$el = @$('#main-content')

  render: =>
    @user = window.MainRouter.User
    @$el.html @template.render {user: @user}

    friends_followers = []

    _.each( @user.following, (a) =>
        _.each( @user.followers, (b) =>
          if a.id is b.id
            friends_followers.push b
        )
      )

    friends = _.uniq(
          friends_followers,
          false,
          (a,b) =>
            a.id is b.id
      )

    if _.isEmpty @user.followers
      @$('ul.follows').append("People doesn't like you.")
    else
      followers = _.difference( @user.followers, friends_followers)

      if _.isEmpty followers
        @$('ul.follows').append("All your followers are friends.")      
      
      else
        _.each followers, (f) =>
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
  new FollowersView(options)