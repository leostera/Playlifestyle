_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "Auth.checkAuthenticated"
  req.use 'App.addToRequest'
  req.use 'debug', 'cyan'  

  {

  SetLocation: (attributes={}) ->
    #Handle both SetLocation(location{str: "Some, where", ...) and SetLocation()

    updateModel = (options, extraData={}) =>
      UserModel = req.app.models.Account.model

      if req.session.user
        UserModel.update({email: req.session.user.email}, options, (err, num) =>
          if num is 1
            UserModel.findOne( {email: req.session.user.email}, (err, user) =>
              req.session.user = user
              req.session.save()
              res { status: yes, user: req.session.user, data: extraData}
            )          
          else if num > 1
            res { status: no }
          else
            res { status: no }
        )
      else
        res { status: no }
  
    #set the location from the users ip
    #in this case fake an address if using localhost
    attributes.ip = "8.8.8.8"
    attributes.ip = req.clientIp unless req.clientIp is "127.0.0.1"

    req.app.actions.Users.Geolocate(attributes.ip, (err, data) =>
      options = {
                $set: {
                  located: yes,
                  location: {
                    ip: attributes.ip, 
                    str: attributes?.str, 
                    lat: data.latitude, 
                    lon: data.longitude
                    }
                  } 
                }        
      updateModel(options, data)
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