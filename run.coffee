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

# Production config
if ss.env == 'production'
  ss.client.packAssets({
    cdn:
      js: (f) -> "http://d3jzxruh9il70w.cloudfront.net/#{f.path}"
      css: (f) -> "http://d3jzxruh9il70w.cloudfront.net/#{f.path}"
  })

  #ss.session.store.use('redis', {host: "redis://leostera:a34f4ede135aefe9e3de4939928c2b45@char.redistogo.com/", port: 9020, db: "char-9020"})
  #ss.publish.transport.use('redis', {host: "redis://leostera:a34f4ede135aefe9e3de4939928c2b45@char.redistogo.com/", port: 9020, db: "char-9020"})
  
# Start! ###
server = http.Server ss.http.middleware
server.listen 3000, "localhost"
ss.start server