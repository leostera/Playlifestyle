# Only let a request through if the session has been authenticated
exports.checkAuthenticated = ->  
  return (req, res, next) ->
    if req.session? and req.session.user? then next()
    else res('Access denied'); # prevent request from continuing
