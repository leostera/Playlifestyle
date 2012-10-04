class ProfileEditView extends Backbone.View

  template: ss.tmpl['views-profileEdit']

  initialize: (options) =>
    @$el = $(options.el)
    @render()
    @$el = @$('#main-content')

  render: =>
    @user = window.MainRouter.User
    @$el.html @template.render {user: @user}

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
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
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
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
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
        ss.rpc("Users.Account.GetUser", {username: f.username}, (res) =>
          if res.status is yes
            console.log res
            @$('#put-followers-here').append( ss.tmpl['partials-follow'].render { username: res.user.username, avatar: res.user.avatar } )
        ) 

    @

  save: (e) =>
    e.preventDefault()
    obj =
      name:
        first: @$('#firstname').val()
        last: @$('#lastname').val()      
      hometown: @$('input#hometown').val()
      gender: @$('input[name=gender]:checked').val()
      bio: @$('textarea#bio').val()

    ss.rpc('Users.Account.Update', obj, (res) => 
      if res.status is yes
        window.MainRouter.User = res.user
        @render()
      )

  changePicture: (e) =>
    e.preventDefault();
    @$('#new-picture').trigger('click')

  uploadPicture: (e) =>
    e.preventDefault()
    console.log e
    file = e.target.files[0]
    reader = new FileReader()
    reader.onload = (event) =>
      ss.rpc('Users.Account.UploadProfilePicture', {type: file.type, raw: event.target.result} , (res) =>        
        if res.status
          cdn = $("img#avatar").attr('src').split('/')
          cdn.pop()
          avatar = cdn.join('/')+"/"+res.user.avatar.split('/').pop()
          $("img#avatar").attr('src',avatar)
          window.MainRouter.User.avatar = res.user.avatar          
        else
          console.log res.message
      )

    console.log file
    reader.readAsDataURL(file)

  rerouteToUser: (e) =>
    e.preventDefault()
    window.MainRouter.navigate @$(e.srcElement).parent().attr('href'), true


  events:
    'click button#saveInfo' : "save"
    'click button#saveBio' : "save"
    'click a#changePicture' : "changePicture"
    'change #new-picture' : "uploadPicture"
    'click ul.follows li a img' : 'rerouteToUser'
    
exports.init = (options={}) ->
  new ProfileEditView(options)