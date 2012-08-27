dbs = "mongodb://playlifestyle:uselesshugepassphrasethatprotectsourdatabase@alex.mongohq.com:10039/play_mongo"
  #dev: "mongodb://playlifestyle:uselesshugepassphrasethatprotectsourdatabase@alex.mongohq.com:10039/play_mongo"
  #prod: "mongodb://playlifestyle:uselesshugepassphrasethatprotectsourdatabase@alex.mongohq.com:10039/play_mongo"

module.exports = (ss)->
  mongoose  = require("mongoose")
  
  ###
  if ss.env == 'production'
    db = dbs.prod
  else
    db = dbs.dev

  mongoose.connect(db)
  ###
  mongoose.connect(dbs)
