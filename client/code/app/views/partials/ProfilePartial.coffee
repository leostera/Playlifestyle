class ProfilePartial extends Backbone.View

  template: ss.tmpl['profile']

  initialize: (options) =>
    @$el = $(options.el)
    @$el.hide()
    @render()
    @$el.fadeIn('fast')

    
  render: =>
    @$el.html @template.render {user: window.MainRouter.User}
    if window.MainRouter.User.sex isnt undefined
      if window.MainRouter.User.sex is true
        @$('#male').attr('checked','true')
      else
        @$('#female').attr('checked','true')
    @

  saveProfile: (e) =>
    e.preventDefault()
    obj =
      name:
        first: @$('#firstname').val()
        last: @$('#lastname').val()
      sex: Boolean(@$('input[name=gender]:checked').val())
      bio: @$('#bio').val()

    ss.rpc('Users.Account.Update', obj, (res) => 
      if res.status is yes
        window.MainRouter.User = res.user
        @render()
        @$('.control-group').addClass('success')
      else
        alert res.message
      )

  restoreFieldValues: (e) =>
    e.preventDefault()

  showProfileTab: (e) =>
    e.preventDefault()

  events:
    'click button#save' : "saveProfile"
    'click button#cancel' : "restoreFieldValues"
    'click button#preview' : "showProfileTab"
    
exports.init = (options={}) ->
  new ProfilePartial(options)