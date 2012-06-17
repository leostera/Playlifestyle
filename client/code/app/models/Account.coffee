class Account extends Backbone.Model

  @errors = {}

  save: =>
    ss.rpc 'Users.Auth.ValidateSignUp', @credentials, (result) =>
      if result is yes
        @trigger 'registration:valid'
        ss.rpc 'Users.Auth.SignUp', @credentials, (result) =>
          if result.status is yes
            @trigger 'registration:success'
          else
            @trigger 'registration:failure'
      else
        @trigger 'registration:invalid'

  validate: (args) =>    
    console.log args
    _.each args, (arg) ->
      ss.rpc 'Users.Auth.ValidateField', arg, (result) =>
        if result.status is yes
          @errors["#{result.field.id}"] = no          
        else
          @errors["#{result.field.id}"] = yes
    
    @errors unless _.isEmpty @errors

exports.model = Account