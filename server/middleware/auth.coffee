# Only let a request through if the session has been authenticated
exports.check = ->  
  return (req, res, next) ->
    if req.session and req.session.userId
      return next()
    res {status: no, error: "Access denied. Invalid session or userId."}