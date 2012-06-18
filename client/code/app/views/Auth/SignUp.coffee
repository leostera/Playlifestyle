class SignUpView extends Backbone.View

  model: require('../../models/Account').model

  templates:
    modal: ss.tmpl['signup-modal']
    wait: [ ss.tmpl['signup-partials-wait'], ss.tmpl['signup-partials-finish'] ]

  el: "#signup"

  step: 0

  initialize: =>
    @user = new @model    

  render: =>
    unless @$el.children().length isnt 0
      @$el.append @templates.modal.render {}
    @$el.modal().show()

    @    

  start: () =>
    ss.rpc("Users.Auth.Status",(res) =>
      @step = res.step
      @changeMessages()
      @doStep()
    )    

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

    window.MainRouter.navigate "signup/#{@url_name}"

    @partial = require("./partials/#{@step_partial}").init({
      model: @user      
    })

    @$('#body').html @partial.render()

    @partial.on "#{@step_event}:proceed", @enableNext
    @partial.on "#{@step_event}:stop", @disableNext

    @

  enableNext: (e) =>        
    @$('#next').removeClass('disabled')

  disableNext: (e) =>
    @$('#next').addClass('disabled')

  next: (e)=>
    e.preventDefault() 

    @partial.disableFields().hideForm()

    @user.set @partial.getModelData()

    @disableNext()
    @showWait(@step)

    callback = (result) =>       
      if result.status is yes
        @partial.off()
        @hideWait()

        @changeMessages()

        if @step < 2
          @showWait(@step)
          @step += 1
          @doStep()
        else
          console.log "now goes the tutorial"
          @trigger 'registration:completed'
      else
        alert result.messages

    switch @step
      when 0 then @user.register(callback)
      when 1 then @user.locate(callback)

  showWait: (step) =>
    if step > 1 then step = 1
    @$('#body').html( @templates.wait[step].render {}).fadeIn()

  hideWait: =>
    @$('#body').html('')

  changeMessages: =>
    if @step is 1
      @$('#title').html("Geolocating you...")
      @$('#next span').html("Finish")
      @$('#steps').html('Step 2/2')
    else if @step is 2
      @$('#next span').html("Start the tutorial")
      @$('#steps').html('Completed =)')

  unroute: (e) =>    
    window.MainRouter.navigate ""

  events:
    'click #close': "unroute"
    'click #next' : "next"
    
exports.init = () ->
  new SignUpView().render().start()