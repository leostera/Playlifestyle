exports.actions = (req, res, ss) ->

# this module does not require auth checks
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
    #check the db for the username and password match
    #check that the user is not logged in yet
    #login the session in redis
    UserModel = require('../../db/Account').model
    UserModel.findOne {email: creds.email, pass: creds.pass}, (err, user) ->
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
    #creds are basically username and password (confirmed)
    #create the user using the creds
    #log him in
    #return his new, unique userId ->
      #thoughts on this, userId might be XXXYYY
      #3 letter 3 digit number
      #ABC123
      #or 25*25*25*1000 = 15625000 combinations

    @error =
      user: yes
      email: yes
      birth: yes
      hometown: yes

    #check for only alphabetic+whitespaces instead of not only whitespace
    if /^[a-zA-Z]{1}[a-zA-Z ]+$/.test creds.user
      @error.user = no
    else
      @error.user = "Invalid username"

    if require("../../utils").IsEmailAvailable(creds.email) is yes
      @error.email = no
    else
      @error.email = "Email already in use"

    # check that is more tan 0 in length (the field)
    # that it's a valid date by parsing it
    # and that has no
    unless isNaN Date.parse creds.birth
      @error.birth = no
    else
      @error.birth = "Invalid birth date"

    #check for only alphabetic+whitespaces instead of not only whitespace
    if /^[a-zA-Z ]+$/.test creds.hometown
      @error.hometown = no
    else
      @error.hometown = "Invalid city name"

    if @error.user is no and @error.email is no and @error.hometown is no and @error.birth is no
      UserModel = require('../../db/Account').model
      newUser = new UserModel
        name: creds.user
        email: creds.email
        hometown: creds.hometown
        birth: creds.birth

      newUser.save (err) ->
        console.log "Error: "
        console.log err
        req.session.setUserId(newUser.user)
        req.session.user = newUser
        req.session.save()
        res {status: yes, step: 1, user: newUser}

    else
      res {status: no, errors: @error}
  }