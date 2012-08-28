module.exports = () ->
  require('knox').createClient( require('../../storage') )