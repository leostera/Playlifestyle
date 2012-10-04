_ = require('underscore')

exports.actions = (req, res, ss) ->

# this module does not require auth checks
#  req.use 'session'
  req.use 'debug', 'cyan'  

  {
  ValidateField: (data) ->

    callback = (r) ->
      _.extend r, {field_id: data.id}
      res r

    switch data.id
      when 'email'
        ss.App.Utils.Validators.isEmailAvailable(data, callback)

      when 'username'
        ss.App.Utils.Validators.isUsernameAvailable(data, callback)

      when 'birthday'
        ss.App.Utils.Validators.checkDate(data, callback)

      when 'location'
        ss.App.Utils.Validators.checkLocation(data, callback)

      when 'password'
        ss.App.Utils.Validators.checkPassword(data, callback)


  }