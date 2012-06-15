class SignUpView extends Backbone.View

  template: ss.tmpl['forms-sign-up-base']

  initialize: (options = {}) =>
    @$el = $ options.el
    @step = options.step
    # Initialize the base form
    @$el.html @template.render {}

    # Class variables
    @views = []    
    if @step isnt 1
      @views.push require('/Registration').init("#sign-up-1")      
    @views.push require('/Geolocate').init("#sign-up-2")   

    if @step isnt 1
      @views[0].bind "registration:success", @geolocateShow
      @views[1].bind "geolocation:hidden", @processShow
      @views[1].bind "geolocation:submitted", @finishProcess
    else
      @views[0].bind "geolocation:hidden", @processShow
      @views[0].bind "geolocation:submitted", @finishProcess

    @

  ###
  #  Rendering and visual effects
  ###
  render: =>
    # Render the views      
    if @step isnt 1  
      @$el.append @views[0].render()
      @views[0].fixDatepicker()
      @$el.append @views[1].render()
    else
      @$el.append @views[0].render()
      @views[0].show()


  geolocateShow: (e) =>
    if @step isnt 1  
      @views[0].kill()
      @views[1].show()
    else
      @views[0].show()

  processShow: (e) =>
    @$('#sign-up-3').fadeIn()
    
  finishProcess: (e) =>
    ss.rpc('Users.Account.IsGeolocated', (result) =>
        if result.status is yes
          window.MainRouter.navigate 'tutorial', true
        else
          window.MainRouter.navigate 'signup', true
      )

  tutorialShow: (e) =>
    #dasd

  ###
  #  Events Table
  ###
  # events:
    
exports.init = (options) ->
  new SignUpView().initialize(options).render()