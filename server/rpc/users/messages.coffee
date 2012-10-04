_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "auth.restrictAccess"
  req.use 'debug', 'cyan'  

  {

  send: (msg) ->
    res { status:no, message: "Not implemented yet" }

  get: () ->
    res { status:no, message: "Not implemented yet" }

  }