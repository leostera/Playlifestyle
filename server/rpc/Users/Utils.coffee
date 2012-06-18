_ = require('underscore')

exports.actions = (req, res, ss) ->

# this module does not require auth checks
#  req.use 'session'
  req.use 'App.addToRequest'
  req.use 'debug', 'cyan'  

  {
  ValidateField: (data) ->
    result =
      status: no
      messages: []      

    switch data.id
      when 'email'
        result = req.app.utils.Validators.isEmailAvailable(data.value)

      when 'username'
        result = req.app.utils.Validators.isUsernameAvailable(data.value)

      when 'birthday'
        result = req.app.utils.Validators.checkDate(data.value)

    _.extend(result, {field_id: data.id})

    res result
  }