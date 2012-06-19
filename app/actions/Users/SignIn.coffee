module.exports = (creds, fn) ->
  UserModel = require('../../models/Account').model
  UserModel.findOne {username: creds.username, password: creds.password}, (err, doc) ->
    fn(err,doc)