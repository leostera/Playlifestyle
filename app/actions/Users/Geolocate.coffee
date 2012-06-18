module.exports = (ip, fn) ->
  city_db?.lookup(ip, (err, data) =>
    console.log err
    console.log data
    fn(err,data)
  )

city_db = module.exports.city_db = {}