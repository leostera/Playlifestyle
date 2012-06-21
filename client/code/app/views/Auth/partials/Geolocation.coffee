class GeolocationPartial extends Backbone.View

  template: ss.tmpl['signup-partials-geoloc']
  
  error:
    location: yes

  ###
  #  Model methods
  ###
  getModelData: =>
    @data = 
      location:
        str: @$('#location').val()

  ###
  #  Rendering and visual effects
  ###
  prerender: =>
    # Render the templates
    @$el.html @template.render {}

    # Hide the icons!
    @$('span.add-on').hide()
    # Typeahead
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

    ss.rpc 'Users.Account.GetLocation', (result) =>
      if result.status is yes    
        ##
        # This code instantiates a new GoogleMap inside div#map and
        # centers it in the LatLng retrieved from the server
        success = (position) ->
          @map = new google.maps.Map document.getElementById('map'), 
            {
              center: new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
              zoom: 1
              mapTypeId: google.maps.MapTypeId.ROADMAP
            }

        navigator.geolocation.getCurrentPosition(success, (e)-> alert e , {maximumAge: 75000})
        ####

        @$('#location').val("#{result.location.city} (#{result.location.country_code})")
        @trigger 'geolocation:proceed'
        #disable the input box
        @disableFields()
      else
        @trigger 'geolocation:stop'   

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

  changeLocation: (e) =>
    e.preventDefault()
    @$('#location').val("")
    @enableFields()

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
        @trigger 'geolocation:proceed'
        @disableFields()
      else
        @trigger 'geolocation:stop'
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
    'click #change' : "changeLocation"
    #validation
    'change input'  : "validateFields"

exports.init = () ->
  new GeolocationPartial().prerender()