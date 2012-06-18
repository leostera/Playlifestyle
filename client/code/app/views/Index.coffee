class IndexView extends Backbone.View

  el: 'body'

  template:
    header: ss.tmpl['index-nav']
    content: ss.tmpl['index-content-main']
    modals: ss.tmpl['index-modals']

  initialize: =>
    ss.rpc "Users.Auth.Status", (res) ->
      if res.status is yes
        window.MainRouter.navigate "#{res.user.name}", true      
      @step = res.step
    @

  render: =>
    #render main template
    $('#nav').html @template.header.render {}
    $('#main').html @template.content.render {}
    $('#modals').html @template.modals.render {}

    #get the login partial view and render it
    @loginPartial = require('./Auth/partials/Login').init()    
    $('#side').html @loginPartial.render()

    @signUpModal = require('./Auth/SignUp').init(@step)

    @

  register: (e) ->
    e.preventDefault()
    @signUpModal = require('./Auth/SignUp').init()
    

  events:
    'click a#register' : "register"

exports.init = ->
  new IndexView().render()
