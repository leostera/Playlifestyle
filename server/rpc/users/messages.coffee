_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "auth.check"
  req.use 'debug', 'cyan'  

  {

  send: (user, msg) ->
    res { status:no, message: "Not implemented yet" }

  get: () ->
    res { status:no, message: "Not implemented yet" }

  }