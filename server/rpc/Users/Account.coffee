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
    user = _.extend obj, {_id: req.session.userId, password: req.session.user.password}
    ss.App.Actions.Users.Update(user, (err, numAffected) =>
      if numAffected == 1
        req.session.user = _.extend(req.session.user, obj)
        req.session.save()
        res { status: yes, user: req.session.user }
      else if numAffected > 1
        res { status: no, message: 'Holy crap you modified someone elses profile!'}
      else 
        res { status: no, message: 'Nothing happened'}
      )

  ShowUser: (user) ->
    ss.App.Actions.Users.Get(user, (err, usr) =>
      if err is null
        res {status:yes, user: usr}
      else
        res {status:no, message: "That user doesn't exits."}
      )
  }