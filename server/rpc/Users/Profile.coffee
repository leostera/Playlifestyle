_ = require('underscore')

exports.actions = (req, res, ss) ->

# this module is secured against unauthenticated guys
  req.use 'session'

  req.use "Auth.checkAuthenticated"

  req.use "App.addToRequest"

  req.use 'debug', 'cyan'  
  {

  #returns the whole userId profile object from db
  #by default userId is the current user's Id
  Get: (userId=req.session.userId) ->
    #get profile from db
    #check relations according to privacy options
    #return it if it exists
    #or false if wrong userId


  #returns true if the new profile is created
  #false if user already has a profile
  Create: ->
    req.app.models.Account.model.findOne(
        {username: req.session.user.username, email: req.session.user.email},
        (err, usr) =>
          if _.isEmpty(usr.profile)
            usr.profile.push {}
            usr.save (err) ->
              res {status: yes}
          else
            res {status:no, profile: usr.profile}
      )

  #upserts a profile
  #if profile attribute is undefined
  #it ignores it
  #and only updates the ones that are being set
  Update: (profile) ->
    req.app.models.Account.model.findOne(
      {username: req.session.user.username, email: req.session.user.email},
      (err, usr) =>
        usr.profile.set profile
        usr.save( (err) ->
          if err?
            res {status: yes, profile: usr.profile}
          else
            res {status:no, message: ["Couldn't update the information..."], profile: usr.profile}
          )
        )
  }