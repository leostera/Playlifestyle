_ = require('underscore')

#City = require('geoip').City
#city_db = module.exports.city_db = new City('./db/GeoLiteCity.dat')

module.exports = (ip, fn) ->
  #if _.isFunction(fn)
  #  city_db?.lookup(ip, (err, data) =>
  #    fn(err,data)
  #  )
  #else
  #  city_db?.lookupSync(ip)
  { }