_ = require('underscore')

Geolocate = module.exports.Geolocate =  (ip, fn) ->
  City = require('geoip').City
  city_db = module.exports.city_db = new City('./db/GeoLiteCity.dat')

  if _.isFunction(fn)
    city_db?.lookup(ip, (err, data) =>
      fn(err,data)
    )
  else
    city_db?.lookupSync(ip)

SignIn = module.exports.SignIn = (creds, fn) ->
  UserModel = require('../../models/Account').model
  UserModel.findOne {username: creds.username, password: creds.password}, (err, doc) ->
    fn(err,doc)

SignUp = module.exports.SignUp = (creds, fn) ->
  UserModel = require('../../models/Account').model
  newUser = new UserModel
    username: creds.username
    email: creds.email
    birthday: creds.birthday

  newUser.save( fn )
