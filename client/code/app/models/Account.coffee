class Account extends Backbone.Model
  rpc:
    create: 'Users.Auth.SignUp'
    locate: 'Users.Account.SetLocation'

  register: (fn) ->
    ss.rpc(@rpc.create, @attributes, fn)

  locate: (fn) ->
    ss.rpc(@rpc.locate, @get('location'), fn)
    
exports.model = Account