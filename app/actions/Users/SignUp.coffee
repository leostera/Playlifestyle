module.exports = (creds, fn) ->

  UserModel = require('../../models/Account').model
  newUser = new UserModel
    username: creds.username
    email: creds.email
    birthday: creds.birthday

  newUser.save( fn )