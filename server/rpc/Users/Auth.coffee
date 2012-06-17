exports.actions = (req, res, ss) ->

# this module does not require auth checks
  req.use 'App.addToRequest'
  req.use 'session'
  req.use 'debug', 'cyan'  

  {

  Status: ->
    #retrieve the current user session state
    #yes for logged in, currently valid
    #false for not logged in or currently not valid
    if req.session?.user
      if req.session.user.located is no
        res {status: no, step: 1}
      else
        res {status: yes, user: req.session.user}
    else
      res {status: no}

  SignIn: (creds) ->
    req.app.actions.Users.SignIn(creds, (err, user) ->
      unless err
        req.session.setUserId(creds.username)
        req.session.user = user
        req.session.save()
        res
          status: yes
          user: user
      else
        res
          status: no
          error: 'Invalid ID'
    )

  SignOut: ->
    #destroy de session!
    #make sure the user is not flagged as logged in in the db
    #make sure the session is marked as not valid anymore in the db
    req.session.setUserId()
    delete req.session.user
    req.session = { }
    if req.session != { }
      res false

    res yes

  SignUp: (creds) ->
    req.app.actions.Users.SignUp(creds, (errors, user) ->
      unless errors
        req.session.setUserId(user.user)
        req.session.user = user
        req.session.save()
        res {status: yes, step: 1, user: user}
      else
        res {status: no, errors: errors}
    )

  ValidateField: (field_data) ->
    validator = "NotEmpty"
    switch field_data?.id
      when 'name' then validator = "Alphabetic"
      when 'email' then validator = "Email"
      when 'date' then validator = "Date"
      
    res { result: req.app.utils.Validators["#{validator}"](field_data), field: field_data }
  }