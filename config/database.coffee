dbs =
  dev: "mongodb://localhost/play_dev"
  prod: "mongodb://nodejitsu:9bf0ff87b7b9dd77c6d29fc92b655032@flame.mongohq.com:27042/nodejitsudb515494115625"

module.exports = (ss)->
  mongoose  = require("mongoose")
  
  if ss.env == 'production'
    db = dbs.prod
  else
    db = dbs.dev

  mongoose.connect(db)
