class RegistrationPartial extends Backbone.View

  template: ss.tmpl['register']

  error:
    username: yes
    password: yes
    email: yes
    birthday: yes

  credentials:
    location: {}

  ###
  #  Model methods
  ###
  getModelData: =>
    @credentials.username = @$('#username').val()
    @credentials.password = @$('#password').val()
    @credentials.email = @$('#email').val()
    @credentials.birthday = @$('#birthday').val()
    @credentials.location.str = @$('#location').val()
    @credentials

  ###
  #  Rendering and visual effects
  ###
  begin: =>
    $('#index').removeClass('limit')
    @$el.hide().removeClass('hide').fadeIn('fast').find('input#username').focus()

  render: =>
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

    $('#ui-datepicker-div').hide()

    ##
    # This code instantiates a new GoogleMap inside div#map and
    # centers it in the LatLng retrieved from the server        
    success = (position) =>
      @map = new google.maps.Map document.getElementById('map'), 
        {
          center: new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
          zoom: 8
          mapTypeId: google.maps.MapTypeId.ROADMAP
        }

      geocode(position.coords.latitude, position.coords.longitude)
      
      @input = document.getElementById("location")
      @autocomplete = new google.maps.places.Autocomplete(@input)
      @autocomplete.bindTo("bounds", @map)

      @marker = new google.maps.Marker({map: @map})

      google.maps.event.addListener @autocomplete, "place_changed", =>
        place = @autocomplete.getPlace();

        if place.geometry.viewport
          @map.fitBounds(place.geometry.viewport)
        else
          @map.setCenter(place.geometry.location)
          @map.setZoom(15)

        @marker.setPosition(place.geometry.location)

    error = (e) => no

    geocode = (lat, lng) =>
      latlng = new google.maps.LatLng(lat, lng)
      geocoder = new google.maps.Geocoder()
      geocoder.geocode({'latLng': latlng}, (results, status) =>
        if status is google.maps.GeocoderStatus.OK
          if (results[1]) 
            locality=0
            for result in results
              if result.types[0] is 'locality'
                locality=result
                #console.log(locality)
                break
          
            for addr_cmp in locality.address_components
              if (addr_cmp.types[0] is "locality")
                city = addr_cmp
              if (addr_cmp.types[0] == "administrative_area_level_1")
                region = addr_cmp
              if (addr_cmp.types[0] is "country")
                country = addr_cmp

            @credentials.location.city = city.long_name
            @credentials.location.region = region.long_name
            @credentials.location.country = country.long_name
            @credentials.location.country_code = country.short_name
            @$('#location').val("#{@credentials.location.city} (#{@credentials.location.country_code})")
        )

    navigator.geolocation.getCurrentPosition(success, error, {maximumAge: 75000})
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
        @$('button#register').removeClass('disabled')
      else
        @$('button#register').addClass('disabled')
    )

  ###
  #  Events
  ###
  triggerLogin: (e) =>
    e.preventDefault()
    @$el.fadeOut "fast", () =>
      @trigger "login:begin"

  onSubmit: (e) =>
    e.preventDefault()

    @$("form#register").fadeOut('fast')
    @$("#wait.hide").fadeIn('fast')

    ss.rpc('Users.Auth.SignUp', @getModelData(), (res) =>
      setTimeout( ()=>
        @$("#wait.hide").fadeOut('fast')
        if res.status is yes                    
          @$("#finish.hide").fadeIn('fast')
          setTimeout( () =>            
            window.MainRouter.navigate('home', true)
          ,2500)
        else 
          @$("#problem.hide").fadeIn('fast')
      , 2000)
    )

    @


  ###
  #  Private
  ###
  __toggleHints: (id, messages) =>
    hint = @$(".control-group##{id}-cg")    
    _.each messages, (msg) =>
      # there's yet only one message to show
      hint.find('p.help-block#message').html(msg)

  __toggleIcons: (id, status) =>
    cg = @$(".control-group##{id}-cg")
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
    'click button#back' : "triggerLogin"
    'click button#register' : 'onSubmit'

exports.init = (options={}) ->
  new RegistrationPartial(options).render()