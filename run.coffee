# SocketStream requires
http      = require('http')
ss        = require('socketstream')

console.log "Running in #{ss.env} environment."

mongoose  = require("mongoose")

assets    = require('./config/assets')
require('./config/formatters')(ss)
require('./config/clients')(ss,assets)
require('./config/routes')(ss)

if ss.env == 'production'
  mongoose.connect("mongodb://nodejitsu:6ec8fb06177bf66545b4f9b43afa7126@flame.mongohq.com:27042/nodejitsudb209414754778")
  #ss.session.store.use('redis',{host: "redis://nodejitsu:3b85497df6dc86d111700ea93f4ecc16@koi.redistogo.com", port:9550, db:"play_redis"});
  #ss.client.packAssets()

else if ss.env == 'fake_production'
  ss.client.packAssets()
  mongoose.connect('mongodb://localhost/play_dev')

else
  mongoose.connect('mongodb://localhost/play_dev')

# Start web server
server = http.Server ss.http.middleware

if ss.env == 'production' or ss.env == 'fake_production' then server.listen 4000
else server.listen 3000

# Start SocketStream server
ss.start server