class IndexView extends Backbone.View

  initialize: (options) =>
    ss.rpc "Users.Auth.Status", (res) ->
      if res.status is yes
        @wontSignUp = yes
        window.MainRouter.navigate "users/#{res.user.username}", true      
      else if res.step is 0 or res.step is 1
        @step = res.step
        @wontSignUp = no
    @

  render: =>
    $('#events').html ss.tmpl['index-events'].render {}
    $('#what-is-play').html ss.tmpl['index-content'].render {}
    $('#modals').html ss.tmpl['index-modals'].render {}
    #get the login partial view and render it
    @loginPartial = require('./Auth/partials/Login').init({el: "#login-form"})    
    @loginPartial.on 'registration:begin', @register
    @loginPartial.render()

    @$('#register').on('click',(e)=>
        e.preventDefault()
        @register()
      )

    @

  register: =>
    unless @wontSignUp
      @signUpModal = require('./Auth/SignUp').init({el: "modal#register"})  
      @signUpModal?.on 'registration:already', (e) =>
        @signUpModal.kill()
        window.MainRouter.navigate '', true

exports.init = (options={})->
  new IndexView(options).render()