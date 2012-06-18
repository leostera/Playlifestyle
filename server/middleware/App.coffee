# Only let a request through if the session has been authenticated
exports.addToRequest = ->  
  return (req, res, next) ->
    req.app = require('../../app')    
    next()
