process.env['SS_ENV'] = 'production'

# SocketStream requires
http      = require('http')
ss        = require('socketstream')

mongoose  = require("mongoose")
mongoose.connect("mongodb://nodejitsu:6ec8fb06177bf66545b4f9b43afa7126@flame.mongohq.com:27042/nodejitsudb209414754778")

assets    = require('./config/assets')

require('./config/formatters')(ss)
require('./config/clients')(ss,assets)
require('./config/routes')(ss)

# ss.client.packAssets()
# Start web server
server = http.Server ss.http.middleware
server.listen 4000
# Start SocketStream server
ss.start server