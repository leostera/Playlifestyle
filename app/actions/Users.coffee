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

  console.log newUser

  newUser.save( fn )

Update = module.exports.Update = (user, obj, fn) ->
  if obj._id
    delete obj._id
  UserModel.update(user, obj, fn)

Get = module.exports.Get = (user, fn) ->
  UserModel.findOne(user, fn)

Follow = module.exports.Follow = (follower, folowee, fn) ->
  conditions = { _id: follower._id, password: follower.password}
  console.log folowee
  result = _.find follower.following, (f) -> return (f.id is folowee._id)
  if result is undefined
    #update the guy being followed
    folowee.followers.push {id: follower._id, username: follower.username}
    folowee_cond = {_id: folowee._id}
      
    Update(folowee_cond, folowee, (err, numAffected) =>

      console.log "Num Affected", numAffected
      if numAffected == 1
        #update the guy who follows
        follower.following.push {id: folowee_cond._id, username: folowee.username}
        #and get the fuck outta here!
        Update(conditions, follower, fn)
    )
    
  else
    fn(null,0)

Unfollow = module.exports.Unfollow = (follower, folowee, fn) ->
  conditions = { _id: follower._id, password: follower.password}

  result = _.find follower.following, (f) -> return (f.id is folowee._id)

  if result isnt undefined
    #update the guy being followed
    folowee.followers = _.reject folowee.followers, (f) -> return (f.id is follower._id)

    folowee_cond = {_id: folowee._id}
      
    Update(folowee_cond, folowee, (err, numAffected) =>

      if numAffected == 1
        #update the guy who follows
        follower.following = _.reject follower.following, (f) -> return (f.id is folowee_cond._id)
        #and get the fuck outta here!
        Update(conditions, follower, fn)
    )
    
  else
    fn(null,0)

UploadProfilePicture = module.exports.UploadProfilePicture = (user, image, fn) ->
  #This should also save resized version of the image!
  fu = require('../utils/FileUploader')

  destination = "/users/#{user.username}/profile/#{image.timestamp}.#{image.type.split('/')[1]}"
  headers =
    'Content-Type': "#{image.type}"
    'x-amz-acl': 'public-read'

  rawData = new Buffer(image.raw.split(";base64,")[1],'base64')

  fu.putBuffer( rawData, destination, headers, (err, res) ->
    if 200 is res.statusCode
      conditions = { _id: user._id, password: user.password }
      user.avatar = destination

      Update(conditions, user, fn)
    else
      fn err, null

  )