module.exports = (ss, express) ->

  ###
  # SocketStream Routes
  ###

  ### Routes
  # Serve the main client on the root URL
  express.get '/', (req, res) ->  
    res.serveClient('main')