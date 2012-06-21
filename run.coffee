# SocketStream requires
http      = require('http')
ss        = require('socketstream')

mongoose  = require("mongoose")

if ss.env == "production"
  mongoose.connect("mongodb://nodejitsu:6ec8fb06177bf66545b4f9b43afa7126@flame.mongohq.com:27042/nodejitsudb209414754778
")
else
  mongoose.connect('mongodb://localhost/play_dev')

assets    = require('./config/assets')

require('./config/formatters')(ss)
require('./config/clients')(ss,assets)
require('./config/routes')(ss)

## Final touchs and launching
# Minimize and pack assets if you type: SS_ENV=production node app.js
if ss.env == 'production' then ss.client.packAssets()

# Start web server
server = http.Server ss.http.middleware

if ss.env == "production"
  server.listen 80
else
  server.listen 3000

# Start SocketStream server
ss.start server