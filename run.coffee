# SocketStream requires
http      = require('http')
ss        = require('socketstream')

console.log "Running in #{ss.env} environment."

require('./config/database')(ss)
require('./config/formatters')(ss)
require('./config/clients')(ss,require('./config/assets'))
require('./config/routes')(ss)

if ss.env == 'production'
  #ss.client.packAssets()
  #ss.session.store.use('redis', {host: "redis://nodejitsu:5af8fee4ff872082871928f186663a1f@chubb.redistogo.com", port: 9276, db: "play_redis"});
  #ss.publish.transport.use('redis', {host: "redis://nodejitsu:5af8fee4ff872082871928f186663a1f@chubb.redistogo.com", port: 9276, db: "play_redis"});

else if ss.env == 'fake_production'
  ss.client.packAssets()

# Start web server
server = http.Server ss.http.middleware

if ss.env == 'production' or ss.env == 'fake_production' then server.listen 4000
else server.listen 3000

# Start SocketStream server
ss.start server