# Require node HTTP Module
http      = require('http')
path      = require('path')
# SocketStream requires
ss        = require('socketstream')
express   = require('express')
# Express
app = express();


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
require('./config/routes')(ss, app)

# Production config
if ss.env == 'production'
  ss.client.packAssets({
    cdn:
      js: (f) -> "http://d3jzxruh9il70w.cloudfront.net#{f.path}"
      css: (f) -> "http://d3jzxruh9il70w.cloudfront.net#{f.path}"
  })

  #ss.session.store.use('redis', {host: "redis://leostera:a34f4ede135aefe9e3de4939928c2b45@char.redistogo.com/", port: 9020, db: "char-9020"})
  #ss.publish.transport.use('redis', {host: "redis://leostera:a34f4ede135aefe9e3de4939928c2b45@char.redistogo.com/", port: 9020, db: "char-9020"})

app.configure( () =>
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.session({secret: "playlifestyle_session_secret"}));
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
)

app.get('/mockup',  (req, res) ->
  res.sendfile(__dirname + '/public/index.html');
)

app.get '/', (req, res) ->  
  res.serveClient('main')

app.get '/home', (req, res) ->  
  res.serveClient('main')

app.get '/notifications', (req, res) ->  
  res.serveClient('main')

app.get '/settings', (req, res) ->  
  res.serveClient('main')

app.get '/messages', (req, res) ->  
  res.serveClient('main')

app.get '/profile', (req, res) ->  
  res.serveClient('main')

app.get '/logout', (req, res) ->  
  res.serveClient('main')

app.get '/users/:username', (req, res) ->  
  res.serveClient('main')

app.get '/active', (req, res) ->
  res.serveClient('main')
  
app.get '/arts', (req, res) ->
  res.serveClient('main')
  
app.get '/culinary', (req, res) ->
  res.serveClient('main')
  
app.get '/fashion', (req, res) ->
  res.serveClient('main')
  
app.get '/buzz', (req, res) ->
  res.serveClient('main')
  
app.get '/music', (req, res) ->
  res.serveClient('main')
  
app.get '/nightlife', (req, res) ->
  res.serveClient('main')
  
app.get '/sports', (req, res) ->
  res.serveClient('main')
  
app.get '/travel', (req, res) ->
  res.serveClient('main')
  
app.get '/friends', (req, res) ->
  res.serveClient('main')

app.get '/following', (req, res) ->
  res.serveClient('main')

app.get '/followers', (req, res) ->
  res.serveClient('main')

# Start! ###
server = app.listen 3000
#server.listen 3000, "localhost"

# Bind tasks, this could live inside a tasks folder I guess
s3client = require('./config/storage').getClient()
fs = require('fs')

ss.events.on "assets:packaged", () =>
  console.log "Deploy assets..."
  fs.readdir('./client/static/assets/main', (err, files) =>
    if files
      for f in files
        console.log "Queued to upload compressed asset #{f}"
        s3client.putFile("./client/static/assets/main/#{f}", "assets/main/#{f}", (errPutFile, result) =>
          if errPutFile then throw errPutFile
          if 200 is result?.statusCode then console.log "Compressed asset #{f} up in Amazon S3 Bucket"
          else console.log "Failed to upload compressed asset #{f} to Amazon S3 Bucket"
        )                   
  )

# Now start the server
ss.start server

# Append SocketStream middleware to the stack
app.stack = app.stack.concat(ss.http.middleware.stack);