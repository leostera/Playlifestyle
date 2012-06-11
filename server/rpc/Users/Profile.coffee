exports.actions = (req, res, ss) ->

# this module is secured against unauthenticated guys
  req.use 'session'

  req.use "Auth.checkAuthenticated"

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
    #check if user has a profile in the db
    #return false if he has
    #otherwise create blank profile
    #and return true so the client can start filling it

  #upserts a profile
  #if profile attribute is undefined
  #it ignores it
  #and only updates the ones that are being set
  Update: (profile) ->
    #blabla
  }