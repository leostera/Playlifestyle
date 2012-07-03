class Profile extends Backbone.Model
  rpc:
    create: 'Users.Profile.Create'
    update: 'Users.Profile.Update'

  create: (fn) ->
    ss.rpc(@rpc.create, fn)

  update: (fn) ->
    ss.rpc(@rpc.update, @attributes, fn)
    
exports.model = Profile