class SignUpView extends Backbone.View

  model: require('../../models/Account').model

  templates:
    modal: ss.tmpl['signup-modal']
    wait: ss.tmpl['signup-partials-wait']

  el: "#signup"

  step: 0

  initialize: =>
    @user = new @model    

  render: =>
    unless @$el.children().length isnt 0
      @$el.append @templates.modal.render {}
    @$el.modal().show()

    @    

  start: (step) =>
    @step = step || 0
    @doStep()

  doStep: =>    
    switch @step
      when 0 
        @step_partial = 'Registration'
        @step_event   = 'registration'
        @url_name     = 'begin'
      when 1 
        @step_partial = 'Geolocation'
        @step_event   = 'geolocation'
        @url_name     = 'geolocate'

    window.MainRouter.navigate "signup/#{@url_name}", true

    @partial = require("./partials/#{@step_partial}").init({
      model: @user      
    })

    console.log @partial.render()

    @$('#body').html @partial.render()

    @partial.on "#{@step_event}:proceed", @enableNext
    @partial.on "#{@step_event}:stop", @disableNext

    @

  enableNext: (e) =>    
    if @step is 0 then @step += 1
    @$('#next').removeClass('disabled')

  disableNext: (e) =>
    @$('#next').addClass('disabled')

  next: =>
    if @step is 0
      return

    @partial.disableFields().hideForm()

    @user.set @partial.getModelData()

    @disableNext()
    @showWait()

    @user.save( (result) =>       
      if result.status is yes
        @partial.off()
        @hideWait()
        @$('#next span').html("Finish")
        @$('#steps').html('Step 2/2')

        @doStep()
      else
        alert result.messages
    )    

  showWait: (options) =>
    @$('#body').html( @templates.wait.render {}).fadeIn()

  hideWait: =>
    @$('#body').html('')

  unroute: (e) =>    
    window.MainRouter.navigate ""

  events:
    'click #close': "unroute"
    'click #next' : "next"
    
exports.init = (step) ->
  new SignUpView().render().start(step)