_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "Auth.checkAuthenticated"
  req.use 'debug', 'cyan'  

  {

  SendMessage: (user, msg) ->
    res { status:no, message: "Not implemented yet" }

  GetMessages: () ->
    res { status:no, message: "Not implemented yet" }

  }