_ = require('underscore')

exports.actions = (req, res, ss) ->

# this module does not require auth checks
#  req.use 'session'
  req.use 'App.addToRequest'
  req.use 'debug', 'cyan'  

  {
  ValidateField: (data) ->

    callback = (r) ->
      _.extend r, {field_id: data.id}
      res r

    switch data.id
      when 'email'
        req.app.utils.Validators.isEmailAvailable(data, callback)

      when 'username'
        req.app.utils.Validators.isUsernameAvailable(data, callback)

      when 'birthday'
        req.app.utils.Validators.checkDate(data, callback)

      when 'location'
        req.app.utils.Validators.checkLocation(data, callback)

  }