_ = require('underscore')
ss = require('socketstream')

# Only let a request through if the session has been authenticated
exports.restrictAccess = ->  
  return (req, res, next) ->
    if req.session.user?
      next()
      ###
      else if not _.isEmpty req.params
        ss.app.actions.users.SignIn(req.params
          , (user) =>
            #init session object
            req.session.user = user
            req.session.setUserId(user._id)
            req.session.save()
            next()
          , (err) =>
            # prevent request from continuing
            res {status:no, error: err}
          )
      ###
    else
      res {status: no, error: "Not logged in and not trying to login. Access denied."}
