_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "auth.restrictAccess"
  req.use 'debug', 'cyan'  

  {

  search: (query) =>
    ss.app.actions.omniSearch.search
    

  }