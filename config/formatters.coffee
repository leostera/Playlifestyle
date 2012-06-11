module.exports = (ss) ->
  # Code Formatters
  ss.client.formatters.add require 'ss-coffee'
  ss.client.formatters.add require 'ss-jade'
  ss.client.formatters.add require 'ss-stylus'
  # Template engine
  ss.client.templateEngine.use require 'ss-hogan' 