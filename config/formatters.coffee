module.exports = (ss) ->
  # Code Formatters
  ss.client.formatters.add require 'ss-coffee'
  ss.client.formatters.add require 'ss-stylus'
  ss.client.formatters.add require 'ss-jade'
  # Template engine
  ss.client.templateEngine.use 'angular'
