exports.actions = (req, res, ss) ->

# this module does not require auth checks
#  req.use 'session'
  req.use 'App.addToRequest'
  req.use 'debug', 'cyan'  

  {
  IsEmailAvailable: (email) ->
    res(not req.app.utils.Email.isTaken email)
  }