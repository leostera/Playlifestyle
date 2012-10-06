_ = require('underscore')
models = require('../models')

search = module.exports.search = (query, fn) =>
  response =
    status: no
    results: []

  regEx = new RegExp("#{query}",'i')

  bringItOn = (err, results) =>
      console.log results
      response.results = results
      unless err
        response.status = yes
      else
        response.error = err

      fn response

  # Here we will add more model searches, right now is just users and usernames
  models.Account.find().or([{'username': regEx},{'name.first': regEx},{'name.last': regEx},{'hometown': regEx}]).exec(bringItOn)