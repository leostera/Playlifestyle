class ProfilePartial extends Backbone.View

  template: ss.tmpl['profile']

  initialize: (options) =>
    @$el = $(options.el)
    @$el.hide()
    @render()
    @$el.fadeIn('fast')

  render: =>
    console.log "Following ", window.MainRouter.User.following
    console.log "Followers ", window.MainRouter.User.followers

    @$el.html @template.render {user: window.MainRouter.User}

    if window.MainRouter.User.gender isnt undefined
      if window.MainRouter.User.gender is "male"
        @$('#gender-male').attr('checked','true')
      else
        @$('#gender-female').attr('checked','true')

    if _.isEmpty window.MainRouter.User.following
      @$('#put-follows-here').append("Apparently you don't like people.")
    else
      _.each window.MainRouter.User.following, (f) ->
        @$('#put-follows-here').append( ss.tmpl['partials-follow'].render { username: f.username } )

    if _.isEmpty window.MainRouter.User.followers
      @$('#put-followers-here').append("People doesn't like you.")
    else
      _.each window.MainRouter.User.followers, (f) ->
        @$('#put-followers-here').append( ss.tmpl['partials-follow'].render { username: f.username } )

    $('form#picture').ajaxForm({
      beforeSubmit: (formData, jqform, options) =>
          if $("#new-picture").val() is ""
            return false
          alert('Uploading image!')
      success: (responseText, statusText, xhr, $form) =>
          obj = 
            avatar:
              url: $('#new-picture').val().toString().split('\\')[2]

          ss.rpc('Users.Account.Update', obj, (res) => 
            alert("Profile picture changed!")
            console.log res
            if res.status is yes
              window.MainRouter.User = res.user
              @render()
            )
          
    })

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

  changePicture: (e) =>
    e.preventDefault();
    @$('#new-picture').trigger('click')

  uploadPicture: (e) =>
    @$('form#picture').submit()

  rerouteToUser: (e) =>
    e.preventDefault()
    window.MainRouter.navigate @$(e.srcElement).attr('href'), true

  events:
    'click button#saveInfo' : "save"
    'click button#saveBio' : "save"
    'click button#changePicture' : "changePicture"
    'change #new-picture' : "uploadPicture"
    'click a#user' : 'rerouteToUser'
    
exports.init = (options={}) ->
  new ProfilePartial(options)