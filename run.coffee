# SocketStream requires
http      = require('http')
ss        = require('socketstream')

mongoose  = require("mongoose")

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

server.listen 3000

# Start SocketStream server
ss.start server