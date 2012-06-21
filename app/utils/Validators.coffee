_ = require('underscore')

###
#  General regexes
###
checkAlphabetic = module.exports.checkAlphabetic = (string) ->
  #check for only alphabetic+whitespaces instead of not only whitespace
  /^[a-zA-Z]{1}[a-zA-Z ]+$/.test string

checkEmail = module.exports.checkEmail = (email) ->
  #ok here use ^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$
  /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$/.test email

checkUsername = module.exports.checkUsername = (user) ->
  /^[a-zA-Z]{1}[-_a-zA-Z0-9]+$/.test user

checkDate = module.exports.checkDate = (date, fn) ->

  result =
    status: no
    messages: []

  splited_date = date.value.split('/')
  if splited_date.length is 3
    date_obj =
      year: splited_date[2]
      month: splited_date[0]-1
      day: splited_date[1]

    if _.isDate( new Date(date_obj.year, date_obj.month, date_obj.day) )
      result.status= yes
      result.messages.push "Birthday is valid."
      
  else
    result.status= no
    result.messages.push "Invalid date."

  fn(result)

checkNotEmpty = module.exports.checkNotEmpty = (string) ->
  /^[ ]*/.test string

checkLocation = module.exports.checkLocation = (location) ->
  # How to check for a location existance by it's name?
  # Probably asking Google Maps would be way better.
  #City = require('geoip').City
  #city_db = module.exports.city_db = new City('./db/GeoLiteCity.dat')
  #city_db?.lookupSync()
  result=
    status: no
    messages: []
  
  if /^[a-zA-Z]{1}[a-zA-Z ]+[,a-zA-Z]{1}[a-zA-Z ]+$/.test location
    result.status= yes
    result.messages.push "Valid location."
  else
    result.messages.push "Invalid location."

  result


###
#  Username validations
###
isValidUsername = module.exports.isValidUsername = (user) ->
  checkUsername(user)

isntValidUsername = module.exports.isntValidUsername = (user) ->
  not isValidUsername(user)

isUsernameTaken = module.exports.isTakenUsername = (user, fn) ->
  require('../models/Account').model.findOne({username: "#{user}"}, (err, usr) =>
    result=
      status: yes
      messages: []

    if _.isNull(usr) and _.isNull(err)
      result.status= no
      result.messages.push "Perfectly valid and available username."
    else
      result.messages.push "Username is taken!"

    fn(result)
  )

isntUsernameTaken = module.exports.isntTakenUsername = (user, fn) ->
  isUsernameTaken(user, (result) ->
    result.status = not result.status
    fn(result)
  )

isUsernameAvailable = module.exports.isUsernameAvailable = (user, fn) ->

  result =
    status: no
    messages: []

  if isntValidUsername(user.value)
    result.messages.push "Username is not valid."
    fn(result)
  else
    isntUsernameTaken(user.value, fn)

###
#  Email validations
###
isValidEmail = module.exports.isValidEmail = (email) ->
  checkEmail(email)

isntValidEmail = module.exports.isntValidEmail = (email) ->
  not isValidEmail(email)

isEmailTaken = module.exports.isTakenEmail = (email, fn) ->
  require('../models/Account').model.findOne({email: "#{email}"}, (err, usr) =>
    result=
      status: yes
      messages: []

    if _.isNull(usr) and _.isNull(err)
      result.status= no
      result.messages.push "Yet unused email."
    else
      result.messages.push "Email already used!"

    fn(result)
  )

isntEmailTaken = module.exports.isntTakenEmail = (email, fn) ->
  isEmailTaken(email, (result) ->
    result.status = not result.status
    fn(result)
  )

isEmailAvailable = module.exports.isEmailAvailable = (email, fn) ->
  result =
    status: no
    messages: []

  if isntValidEmail(email.value)
    result.status = no
    result.messages.push "Email is not valid."
    fn(result)
  else
     isntEmailTaken(email.value, fn)