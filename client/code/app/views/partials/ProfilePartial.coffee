class ProfilePartial extends Backbone.View

  template: ss.tmpl['profile']

  initialize: (options) =>
    @$el = $(options.el)
    @$el.hide()
    @render()
    @$el.fadeIn('fast')

  render: =>
    @$el.html @template.render {user: window.MainRouter.User}
    if window.MainRouter.User.gender isnt undefined
      if window.MainRouter.User.gender is "male"
        @$('#gender-male').attr('checked','true')
      else
        @$('#gender-female').attr('checked','true')
    @

  save: (e) =>
    e.preventDefault()
    obj =
      name:
        first: @$('#firstname').val()
        last: @$('#lastname').val()      
      hometown: @$('input#hometown').val()
      gender: @$('input[name=gender]:checked').val()
      bio: @$('textarea#bio').val()

    ss.rpc('Users.Account.Update', obj, (res) => 
      console.log "Users.Account.Update"
      console.log res
      if res.status is yes
        window.MainRouter.User = res.user
        @render()
      )

  events:
    'click button#save' : "save"
    
exports.init = (options={}) ->
  new ProfilePartial(options)