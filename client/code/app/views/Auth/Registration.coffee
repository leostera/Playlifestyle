class RegistrationView extends Backbone.View

  initialize: (el) =>
    # Class variables
    @template = ss.tmpl['forms-sign-up-1-basic']
    @$el = $(el)
    @error =
      name: yes
      email: yes
      birth: yes
      hometown: yes

    @

  ###
  #  Rendering and visual effects
  ###
  render: =>
    # Render the templates
    @$el.html @template.render {}

    # Init jQuery's DatePicker
    @$('#birth-select').datepicker
      altField: "#birth"
      inline: yes
      duration: "fast"
      minDate: new Date 1940, 1, 1
      maxDate: new Date 1995, 12, 31
      changeMonth: true,
      changeYear: true
      yearRange: 'c-40:c+10'
      onSelect: =>
        e = {}
        e.srcElement = @$('#birth')
        e.srcElement.id = "birth"
        @validateFields(e)

    # this is just ugly, shouldn't be here
    $('#ui-datepicker-div').remove()

    # Hide the icons!
    @$('i').css("visibility",'hidden')
    # Disable the button
    @$('#start').addClass('disabled')

    # Typeahead
    @$('#hometown').typeahead
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

    # Focus the name
    @$('#name').focus()
    # Empty the birthdate
    @$('#birth').val('')

    @trigger 'registration:rendered'

    @

  fixDatepicker: =>
    @$('#birth-select div.ui-datepicker').css('margin-right',"305px").css('float','right')

  disable: =>
    @$('input').attr('disabled','').blur()
    @$('#start').addClass('disabled')
    @$('#sign-in-now').fadeOut()
    @$('#birth-select').slideUp()
    @$('form').animate({
        opacity: 1
        opacity: 0
      }, 1500)

    @

  enable: =>
    @$('#start').removeClass('disabled')
    @$('input').removeAttr('disabled','')
    @$('#birth-select').slideDown()
    @$('#sign-up-1').animate({
        opacity: 0
        opacity: 1
      }, 1500)

    @

  ###
  #  Here is where the magic happens
  ###
  submit: (e) =>
    e.preventDefault()

    unless @__hasErrors()

      @credentials =
        user: @$('#name').val()
        hometown: @$('#hometown').val()
        birth: @$('#birth').val()
        email: @$('#email').val()
        time: Date.now()

      @disable()
      
      #show loading graph

      ss.rpc 'Users.Auth.SignUp', @credentials, (result) =>
        console.log result
        if result.status is yes
          @trigger 'registration:success'
        else
          @trigger 'registration:failure'
          @enable()

  ###
  #  Validations
  ###
  validateFields: (e) =>    
    #cache the element
    el = @$(e.srcElement)

    switch e.srcElement?.id
      when 'name'
        name = el.val()
        #check for only alphabetic+whitespaces instead of not only whitespace
        if /^[a-zA-Z]{1}[a-zA-Z ]+$/.test name
          @error.name = no
          @__toggleIcons(el, no)        
        else
          @error.name = yes
          @__toggleIcons(el, yes)

      when 'email'
        email = el.val()
        #ok here use ^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$
        if /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$/.test email
          ss.rpc("Users.Utils.IsEmailAvailable",email, (result) =>
            if result is yes
              @error.email = no
              @__toggleIcons(el, no)
            else
              @error.email = yes
              @__toggleIcons(el, yes)
            )
        else
          @error.email = yes
          @__toggleIcons(el, yes)

      when 'birth'
        birth = el.val()
        # check it's a valid date by parsing it
        # and that has no
        unless isNaN Date.parse birth
          @error.birth = no
          @__toggleIcons(el, no)
        else
          @error.birth = yes
          @__toggleIcons(el, yes)

      when 'hometown'
        hometown = el.val()
        #check for only alphabetic+whitespaces instead of not only whitespace
        if /^[a-zA-Z ]+$/.test hometown
          @error.hometown = no
          @__toggleIcons(el, no)        
        else
          @error.hometown = yes
          @__toggleIcons(el, yes)

    if @error.hometown is no and @error.email is no \
      and @error.name is no and @error.birth is no
        @$('#start').removeClass('disabled')
        @trigger 'sign-up-proceed'
    else if @$('#start').hasClass('disabled') is no
      @$('#start').addClass('disabled')
      @trigger 'sign-up-halt'

  validateOnTimeout: (e) =>
    @timeOut = setTimeout( =>
        @validateFields e
      , 4000)

  validateNowAndClearTimeouts: (e) =>
    clearTimeout @timeOut
    @validateFields e
  
  ifTabSkipDatepicker: (e) =>
    if e.which is 9 then @$('#hometown').focus()

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

  __hasErrors: =>
    result = false
    if @error.hometown is yes or @error.email is yes or @error.name is yes or @error.birth is yes
      result = yes

    console.log result    
    result

  ###
  #  Events Table
  ###
  events:
    # magiiiiic
    'click #start'  : "submit"
    #validation
    'change input'  : "validateFields"
    'focus input'   : "validateOnTimeout"
    'blur input'    : "validateNowAndClearTimeouts"
    'keydown #birth' : "ifTabSkipDatepicker"

exports.init = (el) ->
  new RegistrationView(el)