module.exports = (creds, fn) ->
  UserModel = require('../../db/Account').model
  UserModel.findOne {email: creds.email, pass: creds.pass}, fn