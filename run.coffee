# Require node HTTP Module
http      = require('http')
# SocketStream requires
ss        = require('socketstream')

console.log "Running in #{ss.env} environment."

# Register our app to be accessed at ss.App in the server
ss.api.add('App', require('./app'))

# Configure the database and initialize it
require('./config/database')(ss)
# Configure the code formatters (CS,Jade,Stylus,Hogan,etc)
require('./config/formatters')(ss)
# Configure the differet clients (Phone, Tablet, Desktop)
require('./config/clients')(ss,require('./config/assets'))
# Configure the routes for serving the clients
require('./config/routes')(ss)


if ss.env != 'development'
  ss.client.packAssets()

if ss.env == 'production'  
  ss.session.store.use('redis', {host: "redis://nodejitsu:5af8fee4ff872082871928f186663a1f@chubb.redistogo.com", port: 9276, db: "play_redis"});
  ss.publish.transport.use('redis', {host: "redis://nodejitsu:5af8fee4ff872082871928f186663a1f@chubb.redistogo.com", port: 9276, db: "play_redis"});
  
# Start web server ###
server = http.Server ss.http.middleware
# Using the appropiate port if not development 
if ss.env != 'development' then server.listen 4000
else server.listen 3000

# Start SocketStream server
ss.start server