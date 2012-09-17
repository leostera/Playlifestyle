_ = require('underscore')

exports.actions = (req, res, ss) ->

# this module does not require auth checks
  req.use 'session'
  req.use 'debug', 'cyan'  

  {

  status: ->
    #retrieve the current user session state
    #yes for logged in, currently valid
    #false for not logged in or currently not valid
    if req?.session?.user?
      if req.session.user.located is no
        res {status: no, step: 1}
      else
        res {status: yes, user: req.session.user}
    else
      res {status: no, step: 0}

  signIn: (creds) ->
    #sign a user in
    ss.app.actions.users.signIn(creds, (err, user) ->
      if user
        req.session.setUserId(user._id)
        req.session.user = user
        req.session.save()
        res
          status: yes
          user: user
      else
        res
          status: no
          error: "No match, try something else."
          user: user
    )

  signOut: ->
    #destroy de session!
    #make sure the user is not flagged as logged in in the db
    #make sure the session is marked as not valid anymore in the db
    req.session.setUserId()
    delete req.session.user
    req.session.save()
    if _.isUndefined(req.session.user)
      res status:yes
    res status:no

  signUp: (creds) ->

    ss.app.actions.users.signUp(creds, (errors, user) ->
      if _.isEmpty errors
        req.session.setUserId(user.user)
        req.session.user = user
        req.session.save()
        res {status: yes, step: 1, user: user}
      else
        res {status: no, errors: errors}
    ) 
    
  }