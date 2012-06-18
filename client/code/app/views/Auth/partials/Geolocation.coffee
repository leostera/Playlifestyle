class GeolocationPartial extends Backbone.View

  template: ss.tmpl['signup-partials-geoloc']
  
  error:
    location: yes

  ###
  #  Rendering and visual effects
  ###
  prerender: =>
    # Render the templates
    @$el.html @template.render {}

    # jQuery

    # Hide the icons!
    @$('span.add-on').hide()

    #disable the input box and continue button
    @disableFields()

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

    @

  render: => @.el

  hideForm: =>
    @$('form').animate({
        opacity: 1
        opacity: 0
      }, 1500)
    @

  showForm: =>
    @$('form').animate({
        opacity: 0
        opacity: 1
      }, 1000)
    @

  enableFields: =>
    @$('#location').removeAttr('disabled').focus()

    @

  disableFields: =>
    @$('#location').attr('disabled','')

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

  ###
  #  Validations
  ###
  validateFields: (e) =>    
    field_data =
      id: e.srcElement?.id || e.target.id
      value: $(e.srcElement || e.target).val()

    ss.rpc( 'Users.Utils.ValidateField', field_data, (result) =>

      console.log result

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
    # magiiiiic
    'click #confirm'  : "confirm"
    'click #decline'  : "decline"
    #validation
    'change input'  : "validateFields"
    'focus input'   : "validateFields"
    'blur input'    : "validateFields"

exports.init = () ->
  new GeolocationPartial().prerender()