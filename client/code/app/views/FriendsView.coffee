class FollowingView extends Backbone.View

  template: ss.tmpl['list']

  initialize: (options) =>
    @$el = $(options.el)
    @render()
    @$el = @$('#main-content')

  render: =>
    @user = window.MainRouter.User
    @$el.html @template.render {user: @user}

    unless _.isEmpty @user.following or _.isEmpty @user.followers
      friends = _.uniq(
          _.union( @user.following, @user.followers),
            false, #unordered list
            (a,b) ->
              a.id is b.id
        );

      _.each friends, (f) =>
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
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