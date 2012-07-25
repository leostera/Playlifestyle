_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "Auth.checkAuthenticated"
  req.use 'App.addToRequest'
  req.use 'debug', 'cyan'  

  {

  SetLocation: (data={}) ->
    data.user = req.session.user
    ss.App.Actions.Users.Geolocate(data, res)    
    
  GetLocation: () ->
    #set the location from the user
    #useful for tracking where the user has been
    ip = "8.8.8.8"
    ip = req.clientIp unless req.clientIp is "127.0.0.1"
    location = ss.App.actions.Users.Geolocate(ip) || {}
    res {status: not _.isEmpty(location), location: location}

  IsGeolocated: () ->
    #true if geolocated already    
    res { status: req.session.user.located, user: req.session.user }
  }