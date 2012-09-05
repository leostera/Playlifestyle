_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "Auth.checkAuthenticated"
  req.use 'debug', 'cyan'  

  {

  SetLocation: (data={}) ->
    data.user = req.session.user
    ss.App.Actions.Users.Geolocate(data, res)    
    
  Update: (obj) ->
    user = {_id: req.session.userId || req.session.user._id, password: req.session.user.password}
    ss.App.Actions.Users.Update(user, obj, (err, numAffected) =>
      if numAffected == 1
        req.session.user = _.extend(req.session.user, obj)
        req.session.save()
        res { status: yes, user: req.session.user }
      else if numAffected > 1
        res { status: no, message: 'Holy crap you modified someone elses profile!'}
      else 
        res { status: no, message: 'Nothing happened'}
      )

  GetUser: (user) ->
    ss.App.Actions.Users.Get(user, (err, usr) =>
      if err is null
        res {status:yes, user: usr}
      else
        res {status:no, message: "That user doesn't exits."}
      )

  UploadProfilePicture: (image) ->
    image = _.extend image, {timestamp: Date.now()}
    ss.App.Actions.Users.UploadProfilePicture req.session.user, image, (err, numAffected) ->
      if err is null and numAffected == 1
        req.session.user.avatar = "/users/#{req.session.user.username}/profile/#{image.timestamp}.#{image.type.split('/')[1]}"
        req.session.save()
        res {status: yes, user: req.session.user }
      else
        res {status: no, message: err}

  Follow: (userToFollow) ->
    ss.App.Actions.Users.Follow req.session.user, userToFollow, (err, numAffected) =>
      if err is null and numAffected == 1
        ss.App.Actions.Users.Get {username: req.session.user.username}, (err, usr) =>
          req.session.user = usr
          req.session.save()

          ss.App.Actions.Users.Get {username: userToFollow.username}, (err, followee) =>
            console.log "Following #{userToFollow.username}", usr, followee
            res { status: yes, user: req.session.user, followee: followee }

      else
        res { status: no, message: "#$%\"& you already following this guy!"}

  Unfollow: (userToUnfollow) ->
    ss.App.Actions.Users.Unfollow req.session.user, userToUnfollow, (err, numAffected) =>
      if err is null and numAffected == 1
        ss.App.Actions.Users.Get {username: req.session.user.username}, (err, usr) =>
          req.session.user = usr
          req.session.save()

          ss.App.Actions.Users.Get {username: userToUnfollow.username}, (err, followee) =>
            res { status: yes, user: req.session.user, followee: followee }

      else
        res { status: no, message: "#$%\"& you ain't following this guy!"}
  }