class Account extends Backbone.Model
  rpc:
    create: 'Users.Auth.SignUp'

  save: (fn) ->
    ss.rpc(@rpc.create,@attributes, fn)
    
exports.model = Account