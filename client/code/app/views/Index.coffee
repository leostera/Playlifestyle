class IndexView extends Backbone.View

  el: 'body'

  template:
    header: ss.tmpl['index-nav']
    content: ss.tmpl['index-content-main']
    modals: ss.tmpl['index-modals']

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
    #render main template
    $('#nav').html @template.header.render {}
    $('#main').html @template.content.render {}
    $('#modals').html @template.modals.render {}

    #get the login partial view and render it
    @loginPartial = require('./Auth/partials/Login').init()    
    $('#side').html @loginPartial.render()

    @

  register: =>
    unless @wontSignUp
      @signUpModal = require('./Auth/SignUp').init(@step)  
      @signUpModal?.on 'registration:already', (e) =>
        @signUpModal.kill()
        window.MainRouter.navigate ''

  registerFromLink: (e) ->
    e.preventDefault()

    unless @wontSignUp    
      @register()

  events:
    'click a#register' : "registerFromLink"

exports.init = (options={})->
  new IndexView(options).render()
