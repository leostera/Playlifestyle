_ = require('underscore')
models = require('../models')

search = module.exports.search = (query, fn) =>
  response =
    status: no
    results: []

  # Here we will add more model searches, right now is just users and usernames
  models.Account.find {username: new RegExp("#{query}",'i')}, 'username name avatar', (err, results) =>
    response.results = results
    unless err
      response.status = yes
    else
      response.error = err

    fn response