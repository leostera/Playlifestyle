
class ProfilePartial extends Backbone.View

  template: ss.tmpl['profile-by-username']

  initialize: (options) =>
    @username = options.username
    @user = {}
    @$el = $(options.el)
    @$el.hide()
    ss.rpc('Users.Account.ShowUser',{username: @username},(res) =>
      console.log res
      if res.status is yes
        @user = res.user
        @render()
        @$el.fadeIn('fast')
      else
        @render()
    )
    

  render: =>
    @$el.html @template.render {user: @user}

    if @user is {}
      @$('#user').hide()
      @$('#fail').show()
    else
      @$('#fail').hide()
      @$('#user').show()
      
    @

  events:
    'click button#add'    : "render"
    'click button#message': "render"
    'click button#invite' : "render"
    
exports.init = (options={}) ->
  new ProfilePartial(options)