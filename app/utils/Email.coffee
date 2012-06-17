module.exports.isValid = (email) ->
  require('./Validators').Email(email)

module.exports.isntValid = (email) ->
  not isValid(email)

module.exports.isTaken = (email) ->
  no

module.exports.isntTaken = (email) ->
  not isTaken(email)