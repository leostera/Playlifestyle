utils = require("../../utils")

exports.actions = (req, res, ss) ->

# this module does not require auth checks
#  req.use 'session'
  req.use 'debug', 'cyan'  

  {
  IsEmailAvailable: (email) ->
    res utils.IsEmailAvailable email
  }