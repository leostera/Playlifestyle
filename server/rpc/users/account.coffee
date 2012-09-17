_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "auth.check"
  req.use 'debug', 'cyan'  

  {
  update: (obj) ->
    user = {_id: req.session.userId || req.session.user._id, password: req.session.user.password}
    ss.app.actions.users.update(user, obj, (err, numAffected) =>
      if numAffected == 1
        req.session.user = _.extend(req.session.user, obj)
        req.session.save()
        res { status: yes, user: req.session.user }
      else if numAffected > 1
        res { status: no, message: 'Holy crap you modified someone elses profile!'}
      else 
        res { status: no, message: 'Nothing happened'}
      )

  getUser: (user) ->
    ss.app.actions.users.get(user, (err, usr) =>
      if err is null
        res {status:yes, user: usr}
      else
        res {status:no, message: "That user doesn't exits."}
      )

  uploadProfilePicture: (image) ->
    image = _.extend image, {timestamp: Date.now()}
    ss.app.actions.users.uploadProfilePicture req.session.user, image, (err, numAffected) ->
      if err is null and numAffected == 1
        req.session.user.avatar = "/users/#{req.session.user.username}/profile/#{image.timestamp}.#{image.type.split('/')[1]}"
        req.session.save()
        res {status: yes, user: req.session.user }
      else
        res {status: no, message: err}

  follow: (userToFollow) ->
    ss.app.actions.users.follow req.session.user, userToFollow, (err, numAffected) =>
      if err is null and numAffected == 1
        ss.app.actions.users.get {username: req.session.user.username}, (err, usr) =>
          req.session.user = usr
          req.session.save()

          ss.app.actions.users.get {username: userToFollow.username}, (err, followee) =>
            console.log "Following #{userToFollow.username}", usr, followee
            res { status: yes, user: req.session.user, followee: followee }

      else
        res { status: no, message: "#$%\"& you already following this guy!"}

  unfollow: (userToUnfollow) ->
    ss.app.actions.users.unfollow req.session.user, userToUnfollow, (err, numAffected) =>
      if err is null and numAffected == 1
        ss.app.actions.users.get {username: req.session.user.username}, (err, usr) =>
          req.session.user = usr
          req.session.save()

          ss.app.actions.users.get {username: userToUnfollow.username}, (err, followee) =>
            res { status: yes, user: req.session.user, followee: followee }

      else
        res { status: no, message: "#$%\"& you ain't following this guy!"}
  }