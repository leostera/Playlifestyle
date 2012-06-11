module.exports = (ss, express) ->

  ###
  # SocketStream Routes
  ###

  ## Routes
  # Serve the main client on the root URL
  ss.http.route '/', (req, res) ->  
    res.serveClient('main')