_ = require('underscore')
crypto = require('crypto')

UserModel = require('../models/Account').model

Geolocate = module.exports.Geolocate =  (data, fn) ->
  options = {
            $set: {
              located: yes,
              location: {
                ip: data.ip, 
                str: data?.str, 
                lat: data.latitude, 
                lon: data.longitude
                }
              } 
            }        

  UserModel.update({email: data.user.email}, options, (err, num) =>
    if num is 1
      UserModel.findOne( {email: data.user.email}, (err, user) =>
        fn { status: yes, data: data}
      )          
    else if num > 1
      fn { status: no }
    else
      fn { status: no }
  )

SignIn = module.exports.SignIn = (creds, fn) ->  
  UserModel.findOne {username: creds.username.toLowerCase(), password: crypto.createHash('md5').update(creds.password).digest("hex")}, (err, doc) ->
    fn(err,doc)

SignUp = module.exports.SignUp = (creds, fn) ->
  newUser = new UserModel
    username: creds.username
    email: creds.email
    birthday: creds.birthday
    password: crypto.createHash('md5').update(creds.password).digest("hex").toString()
    location: creds.location

  newUser.save( fn )

Update = module.exports.Update = (user, fn) ->
  conditions = { _id: user._id, password: user.password }
  delete user._id
  UserModel.update(conditions, user, fn)

Get = module.exports.Get = (user, fn) ->
  UserModel.findOne(user, fn)