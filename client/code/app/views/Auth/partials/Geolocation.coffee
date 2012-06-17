class GeolocationPartial extends Backbone.View

  @template: ss.tmpl['signup-partials-geoloc']
  @error:
    location: yes

  ###
  #  Rendering and visual effects
  ###
  prerender: =>
    # Render the templates
    @$el.html @template.render {}

    # jQuery

    # Hide the icons!
    @$('i').css("visibility",'hidden')

    #disable the input box and continue button
    @disable()

    @$('#location').typeahead
      source: ['Calgary', 'Vancouver', 'Tucuman']
        ###
        (req, res) =>
        choices = []
        ss.rpc("Contents.Cities.ByLocation",{near: req.term}, (resNear) =>
          choices.push resNear

          ss.rpc("Contents.Cities.ByName",{like: req.term}, (resLike) =>
            choices.push resLike

            response [choices[0]..., choices[1]...]
        ###
      minLength: 3

    @$('form').hide()

    @

  render: =>
    @.el

  hide: =>
    @$('#locate').slideUp()
    @$('form').animate({
        opacity: 1
        opacity: 0
      }, {
        duration:1500
        complete: => @trigger 'geolocation:hidden'
      })

  show: =>
    @$('form').css('opacity','0.0').show().animate({
        opacity: 0
        opacity: 1
      }, {
        duration:1000
        complete: => @trigger 'geolocation:shown'
      })

  enable: =>
    @$('#continue').removeClass('disabled')
    @$('#location').removeAttr('disabled').focus()

    @

  disable: =>
    @$('#location').attr('disabled','')
    @$('#continue').addClass('disabled')

    @

  ###
  #  Here is where the magic happens
  ###
  confirm: (e) =>
    e.preventDefault()

    unless @canProceed()
      return

    @disable().hide()
    
    #show loading graph

    ss.rpc 'Users.Account.SetLocation', (result) =>
      if result.status is yes        
        @trigger 'geolocation:submitted'
      else
        @trigger 'geolocation:error'

  decline: (e) =>
    e.preventDefault()

    @enable()

  canProceed: =>
    not /^(\s)*$/.test @$('#location').val()

  ###
  #  Validations
  ###
  validateFields: (e) =>    
    #cache the element
    el = @$(e.srcElement)

    switch e.srcElement?.id
      when 'location'
        location = el.val()
        #check for only alphabetic+whitespaces instead of not only whitespace
        if /^[a-zA-Z]{1}[a-zA-Z ]+$/.test location
          @error.location = no
          @__toggleIcons(el, no)        
        else
          @error.location = yes
          @__toggleIcons(el, yes)

    if @error.location is no
        @$('#confirm').removeClass('disabled')
        @trigger 'sign-up-proceed'
    else if @$('#start').hasClass('disabled') is no
      @$('#confirm').addClass('disabled')
      @trigger 'sign-up-halt'

  ###
  #  Private
  ###
  __toggleIcons: (el,toggle=yes,error="") =>
    name = el.attr('id')
    parent = el.parent()
    if toggle is yes
      parent.addClass('error')
      parent.removeClass('success')
      el.siblings().find('#error-'+name).css('visibility','visible').text(error)
      el.siblings().find('#error-'+name).show('fast')
      el.siblings().find('#ok-'+name).hide('fast')
    else
      parent.removeClass('error')
      parent.addClass('success')
      el.siblings().find('#error-'+name).hide('fast')
      el.siblings().find('#ok-'+name).css('visibility','visible').text('')
      el.siblings().find('#ok-'+name).show('fast')

  ###
  #  Events Table
  ###
  events:
    # magiiiiic
    'click #confirm'  : "confirm"
    'click #decline'  : "decline"
    #validation
    'change input'  : "validateFields"
    'focus input'   : "validateFields"
    'blur input'    : "validateFields"

exports.init = () ->
  new GeolocationPartial().prerender()