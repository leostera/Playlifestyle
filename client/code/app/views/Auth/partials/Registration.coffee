class RegistrationPartial extends Backbone.View

  template: ss.tmpl['signup-partials-start']

  error:
    username: yes
    email: yes
    birthday: yes

  ###
  #  Model methods
  ###
  getModelData: =>
    @credentials = 
      username: @$('#username').val()
      email: @$('#email').val()
      birthday: @$('#birthday').val()

  ###
  #  Rendering and visual effects
  ###
  prerender: =>
    # Render the templates
    @$el.html @template.render {}

    # Hide the icons!
    @$('span.add-on').hide()

    # Init jQuery's DatePicker
    @$('input#birthday', @$el).datepicker
        duration: "fast"
        minDate: new Date(1940, 1, 1)
        maxDate: new Date(1995, 12, 31)
        changeMonth: true
        changeYear: true
        yearRange: 'c-40:c+10'

    @
  
  render: => @.el

  disableFields: =>
    @$('input').attr('disabled','').blur()
    @

  hideForm: =>
    @$('#signup-1').animate({
        opacity: 1
        opacity: 0
      }, 1500)
    @

  enableFields: =>
    @$('input').removeAttr('disabled','')    
    @

  showForm: =>
    @$('#signup-1').animate({
        opacity: 0
        opacity: 1
      }, 1500)
    @

  ###
  #  Validations
  ###
  validateFields: (e) =>    
    field_data =
      id: e.srcElement?.id || e.target.id
      value: $(e.srcElement || e.target).val()

    ss.rpc( 'Users.Utils.ValidateField', field_data, (result) =>

      @error["#{result.field_id}"] = not result.status
      @__toggleHints(result.field_id, result.messages)
      @__toggleIcons(result.field_id, not result.status)

      unless @__hasErrors()
        @trigger 'registration:proceed'
      else
        @trigger 'registration:stop'
    )

  ###
  #  Private
  ###
  __toggleHints: (id, messages) =>
    hint = $(".control-group##{id}-cg .controls")
    hint.find('p.help-block').html("")
    _.each messages, (msg) =>
      hint.append("<p class=\'help-block'>#{msg}</p>")

  __toggleIcons: (id, status) =>
    cg = $(".control-group##{id}-cg")
    cg.removeClass('error').removeClass('success')
    if status is yes
      cg.addClass('error')
      cg.find('span#error').show('fast')
      cg.find('span#ok').hide('fast')
    else
      cg.addClass('success')
      cg.find('span#error').hide('fast')
      cg.find('span#ok').show('fast')

  __hasErrors: =>
    result = false
    _.each @error, (e) =>
      if e is yes
        result = yes
    result

  ###
  #  Events Table
  ###
  events:
    #validation
    'change input'  : "validateFields"

exports.init = (options={}) ->
  new RegistrationPartial(options).prerender()