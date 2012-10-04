_ = require('underscore')

exports.actions = (req, res, ss) ->

  req.use 'session'
  req.use "auth.restrictAccess"
  req.use 'debug', 'cyan'  

  {

  search: (query) =>
    ss.app.actions.omniSearch.search(query, (result) =>
      if result.status is yes
        res { status: yes, results: result.results }
      else
        res { status: no}
    )
    

  }