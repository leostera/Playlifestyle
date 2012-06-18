class Account extends Backbone.Model
  rpc:
    create: 'Users.Auth.SignUp'
    locate: 'Users.Account.SetLocation'

  save: (fn) ->
    ss.rpc(@rpc.create,@attributes, fn)

  locate: (fn) ->
    ss.rpc(@rpc.locate,@attributes, fn)
    
exports.model = Account