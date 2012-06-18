_ = require('underscore')

###
#  General regexes
###
checkAlphabetic = module.exports.checkAlphabetic = (string) ->
  #check for only alphabetic+whitespaces instead of not only whitespace
  status: /^[a-zA-Z]{1}[a-zA-Z ]+$/.test string

checkEmail = module.exports.checkEmail = (email) ->
  #ok here use ^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$
  /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$/.test email

checkUsername = module.exports.checkUsername = (user) ->
  /^[a-zA-Z]{1}[-_a-zA-Z0-9]+$/.test user

checkDate = module.exports.checkDate = (date) ->

  console.log date

  result = 
    status: no
    messages: []

  splited_date = date.split('/')
  if splited_date.length is 3
    date =
      year: date[2]
      month: date[0]-1
      day: date[1]

    if _.isDate( new Date(date.year, date.month, date.day) )
      result.status= yes
      result.messages.push "Birthday is valid."
      
  else
    result.status= no
    result.messages.push "Invalid date."

  result

checkNotEmpty = module.exports.checkNotEmpty = (string) ->
  /^[ ]*/.test string

###
#  Username validations
###
isValidUsername = module.exports.isValidUsername = (user) ->
  checkUsername(user)

isntValidUsername = module.exports.isntValidUsername = (user) ->
  not isValidUsername(user)

isUsernameTaken = module.exports.isTakenUsername = (user) ->
  require('../models/Account').model.findOne({username: user}, (err, usr) -> )
  no

isntUsernameTaken = module.exports.isntTakenUsername = (user) ->
  not isUsernameTaken(user)

isUsernameAvailable = module.exports.isUsernameAvailable = (user) ->
  result =
    status: no
    messages: []

  if isValidUsername(user) and isntUsernameTaken(user)
    result.status = yes
    result.messages.push "Username valid and available."

  if isntValidUsername(user)
    result.status = no
    result.messages.push "Username is not valid."

  if isUsernameTaken(user)
    result.status = no
    result.messages.push "Username is not available."

  result

###
#  Email validations
###
isValidEmail = module.exports.isValidEmail = (email) ->
  checkEmail(email)

isntValidEmail = module.exports.isntValidEmail = (email) ->
  not isValidEmail(email)

isEmailTaken = module.exports.isTakenEmail = (email) ->
  no

isntEmailTaken = module.exports.isntTakenEmail = (email) ->
  not isEmailTaken(email)

isEmailAvailable = module.exports.isEmailAvailable = (email) ->
  result =
    status: no
    messages: []

  if isValidEmail(email) and isntEmailTaken(email)
    result.status = yes
    result.messages.push "Email valid and not used yet."

  if isntValidEmail(email)
    result.status = no
    result.messages.push "Email is not valid."

  if isEmailTaken(email)
    result.status = no
    result.messages.push "Email already used."

  result