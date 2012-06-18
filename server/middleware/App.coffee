# Only let a request through if the session has been authenticated
exports.addToRequest = ->  
  return (req, res, next) ->
    req.app = require('../../app')
    req.app.actions.Users.Geolocate.city_db = new geoip.City('./../../db/GeoLiteCity.dat')
    next()
