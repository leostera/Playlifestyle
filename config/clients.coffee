module.exports = (ss, assets) ->
	# Define main client
	ss.client.define 'main', 
	  view: 'app.jade'
	  css:  assets.desktop_style
	  code: assets.desktop_code
	  tmpl: '*'

  ###
  ss.client.define 'phone',
    view: 'phone.jade'
    css:  assets.phone_style
    code: assets.phone_code
    tmpl: 'phone/*'

  ss.client.define 'tablet',
    view: 'tablet.jade'
    css:  assets.tablet_style
    code: assets.tablet_code
    tmpl: 'tablet/*'
  ###