_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "Auth.checkAuthenticated"
  req.use 'App.addToRequest'
  req.use 'debug', 'cyan'  

  {

  SetLocation: () ->
    #set the location from the user
    #useful for tracking where the user has been
    ip = "8.8.8.8"
    ip = req.clientIp unless req.clientIp is "127.0.0.1"
    
    req.app.actions.Users.Geolocate(ip, (err, data) =>

      UserModel = req.app.models.Account.model
      if req.session?.user?
        UserModel.update({email: req.session.user.email}, { $set: {located: yes, location: {lat: data.latitude, lon: data.longitude} } }, (err, num) =>
          if num is 1
            UserModel.findOne( {email: req.session.user.email}, (err, user) =>
              req.session.user = user
              req.session.save()
              res { status: yes, data: data, user: req.session.user }
            )          
          else if num > 1
            res { status: no }
          else
            res { status: no }
        )
      else
        res { status: no }
    )

  GetLocation: () ->
    #set the location from the user
    #useful for tracking where the user has been
    ip = "8.8.8.8"
    ip = req.clientIp unless req.clientIp is "127.0.0.1"
    location = req.app.actions.Users.Geolocate(ip) || {}
    res {status: not _.isEmpty(location), location: location}

  IsGeolocated: () ->
    #true if geolocated already    
    res { status: req.session.user.located, user: req.session.user }
  }