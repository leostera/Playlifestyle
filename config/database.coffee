dbs =
  dev: "mongodb://localhost/play_dev"
  prod: "mongodb://nodejitsu:6ec8fb06177bf66545b4f9b43afa7126@flame.mongohq.com:27042/nodejitsudb209414754778"

module.exports = (ss)->
  mongoose  = require("mongoose")
  
  if ss.env == 'production'
    db = dbs.prod
  else
    db = dbs.dev

  mongoose.connect(db)
