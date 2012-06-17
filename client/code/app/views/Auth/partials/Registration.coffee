class RegistrationPartial extends Backbone.View

  template: ss.tmpl['signup-partials-start']

  error =
    name: yes
    email: yes
    birth: yes
    hometown: yes

  ###
  #  Rendering and visual effects
  ###
  prerender: =>
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

    @
  
  render: =>
    @.el

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

    @credentials =
      user: @$('#name').val()
      hometown: @$('#hometown').val()
      birth: @$('#birth').val()
      email: @$('#email').val()
      time: Date.now()

    ss.rpc 'Users.Auth.ValidateSignUp', @credentials, (result) =>
      if result is yes
        @disable()
        ss.rpc 'Users.Auth.SignUp', @credentials, (result) =>
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
    cache_el = @$(e.srcElement)
    cache_id = cache_el.srcElement?.id
    cache_val = cache_el.val()

    field_data = {   
      el: cache_el
      id: cache_id
      value: cache_val
    }

    ss.rpc 'Users.Auth.ValidateField', field_data, (result) =>
      if result.status is yes
        @error["#{result.field.id}"] = no
        @__toggleIcons(result.field.el, no)
      else
        @error["#{result.field.id}"] = yes
        @__toggleIcons(result.field.el, yes)

    if @error.hometown is no and @error.email is no \
      and @error.name is no and @error.birth is no
        @$('#start').removeClass('disabled')
        @trigger 'registration:proceed'
    else if @$('#start').hasClass('disabled') is no
      @$('#start').addClass('disabled')

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

exports.init = (options={}) ->
  new RegistrationPartial(options).prerender()