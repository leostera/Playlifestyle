exports.actions = (req, res, ss) ->

  req.use 'App.addToRequest'
  req.use 'session'
  req.use "Auth.checkAuthenticated"
  req.use 'debug', 'cyan'  

  {

  SetLocation: (coord={lon: 0, lat: 0}) ->
    #set the location from the user
    #useful for tracking where the user has been
    UserModel = req.app.models.Account.model
    if req.session?.user?
      UserModel.update({email: req.session.user.email}, { $set: {located: yes} }, (err, num) =>
        if num is 1
          UserModel.findOne( {email: req.session.user.email}, (err, user) =>
            req.session.user = user
            req.session.save()
            res { status: yes, user: req.session.user }
          )          
        else if num > 1
          res { status: no }
        else
          res { status: no }
      )
      console.log req.session.user
    else
      res { status: no }

  IsGeolocated: () ->
    #true if geolocated already    
    res { status: req.session.user.located, user: req.session.user }
  }