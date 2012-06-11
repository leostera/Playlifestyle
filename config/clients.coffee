module.exports = (ss, assets) ->
	# Define main client
	ss.client.define 'main', 
	  view: 'app.jade'
	  css:  assets.style_in_order
	  code: assets.code_in_order
	  tmpl: '*'