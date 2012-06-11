# Only let a request through if the session has been authenticated
exports.checkAuthenticated = ->  
  return (req, res, next) ->
    #perform authentication based on the logging info in the db
    #if the current session id is not valid anymore
    #then deny access
    
    if req.session? and req.session.user? then next()
    else res('Access denied'); # prevent request from continuing
