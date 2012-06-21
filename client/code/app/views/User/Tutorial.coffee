class TutorialView extends Backbone.View

  model: require('../../models/Profile').model

  templates:
    nav: ss.tmpl['tutorial-nav']
    full: ss.tmpl['tutorial-content-full']
    steps: [
      ss.tmpl['tutorial-partials-step-0']
      ss.tmpl['tutorial-partials-step-1']
      ss.tmpl['tutorial-partials-step-2']
      ss.tmpl['tutorial-partials-step-3']
      ss.tmpl['tutorial-partials-step-4']
      ss.tmpl['tutorial-partials-step-5']
      ss.tmpl['tutorial-partials-step-6']
    ]
    
  el: "#tutorial"

  step: 0

  initialize: =>
    @profile = new @model  
  
  render: =>
    $('#full').html @templates.full.render {}
    $('#side').hide()
    $('#main').hide()
    $('#nav').html @templates.nav.render {}
    @

  start: () =>
    ss.rpc("Users.Auth.Status",(res) =>
      if res.status is no
        window.MainRouter.navigate '', true
        @kill()
      else
        ss.rpc("Users.Profile.Create", (res) =>
          @step = 0
          if res.status is no
            @profile.set res.status.profile            
        )
    )    

  doStep: =>    
    #0 Avatar
    #1 Gender
    #2 Anniversaries
    #3 Bio
    #4 Status
    #5 Interests
    #6 Contact
    #7 Finish
    switch @step
      when 0 
        @step_partial = 'Avatar'
        @step_event   = 'avatar'
        @url_name     = 'avatar'
      when 1 
        @step_partial = 'Gender'
        @step_event   = 'gender'
        @url_name     = 'gender'
      when 2
        @step_partial = 'Gender'
        @step_event   = 'gender'
        @url_name     = 'gender'
      when 3 
        @step_partial = 'Gender'
        @step_event   = 'gender'
        @url_name     = 'gender'
      when 4 
        @step_partial = 'Gender'
        @step_event   = 'gender'
        @url_name     = 'gender'
      when 5 
        @step_partial = 'Gender'
        @step_event   = 'gender'
        @url_name     = 'gender'
      when 6 
        @step_partial = 'Gender'
        @step_event   = 'gender'
        @url_name     = 'gender'                                
      when 7
        @step_partial = no
        @step_event   = no
        @url_name     = 'finish'                

    window.MainRouter.navigate "tutorial/#{@url_name}"

    if _.isString(@step_partial)
      @partial = require("./partials/#{@step_partial}").init({
        model: @profile      
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

      @profile.set @partial.getModelData()

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
      when 0 then @profile.register(callback)
      when 1 then @profile.locate(callback)
      when 2 then @trigger 'registration:completed'

  events:
    'click #next' : "next"
  
exports.init = (options={}) ->
  new TutorialView(options).render().start()
  