module.exports = (ip, fn) ->
  geoip = require('geoip')
  city = new geoip.City('../../../db/GeoLiteCity.dat')

  city.lookup(ip, fn)