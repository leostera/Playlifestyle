class SignUpView extends Backbone.View

  model: require('../../models/Account').model

  templates:
    modal: ss.tmpl['signup-modal']
    wait: [ ss.tmpl['signup-partials-wait'],
            ss.tmpl['signup-partials-finish'],
            ss.tmpl['signup-partials-benefits']
          ]

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
      if res.status is no
        @step = res.step
        @changeMessages()
        @doStep()
      else
        @trigger 'registration:already'
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
      when 2
        @step_partial = no
        @step_event   = no
        @url_name     = 'finish'                
        @showWait(@step)
        @enableNext()

    window.MainRouter.navigate "signup/#{@url_name}"

    if _.isString(@step_partial)
      @partial = require("./partials/#{@step_partial}").init({
        model: @user      
        })

      @$('#body').html @partial.render()

      @partial.on "#{@step_event}:proceed", @enableNext
      @partial.on "#{@step_event}:stop", @disableNext

    @

  enableNext: (e) =>
    @canProceed = yes
    @$('#next').removeClass('disabled')

  disableNext: (e) =>
    @canProceed = no
    @$('#next').addClass('disabled')

  next: (e)=>
    unless @canProceed
      return

    e.preventDefault()

    if @partial?

      @partial.disableFields().hideForm()

      @user.set @partial.getModelData()

    unless @step is 2
      @disableNext()
      @showWait(@step)

    callback = (result) =>       
      if result.status is yes
        @partial?.off()
        @hideWait()
        @step += 1
        @changeMessages()
        @doStep()       
      else
        alert result.messages

    switch @step
      when 0 then @user.register(callback)
      when 1 then @user.locate(callback)
      when 2 then @trigger 'registration:completed'

  #show the waiting partial in the #body
  showWait: (step) =>
    @$('#body').html( @templates.wait[step].render {}).fadeIn()

  #hide the body when it contains a waiting partial
  hideWait: =>
    @$('#body').html('')

  #change the messages according to the registration step
  changeMessages: =>
    if @step is 1
      @$('#title').html("Geolocating you...")
      @$('#next span').html("Finish")
      @$('#steps').html('Step 2/2')
    else if @step is 2
      @$('#title').html("Registration completed")
      @$('#next span').html("Start the tutorial now!")
      @$('#steps').html('Registration completed =)')

  unroute: (e) =>    
    window.MainRouter.navigate ""

  events:
    'click #close': "unroute"
    'click #next' : "next"
    
exports.init = () ->
  new SignUpView().render().start()