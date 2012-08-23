dbs =
  dev: "mongodb://nodejitsu:ac12968680ce8329c8a136be9c2e3e3e@alex.mongohq.com:10090/nodejitsudb885971376864"#"mongodb://localhost/play_dev"
  prod: "mongodb://nodejitsu:ac12968680ce8329c8a136be9c2e3e3e@alex.mongohq.com:10090/nodejitsudb885971376864"

module.exports = (ss)->
  mongoose  = require("mongoose")
  
  if ss.env == 'production'
    db = dbs.prod
  else
    db = dbs.dev

  mongoose.connect(db)
