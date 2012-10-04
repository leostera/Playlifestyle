models = require('../models')

search = module.exports.search = (query) =>
  response =
    status: no
    results: []

  # Here we will add more model searches, right now is just users and usernames
  models.Account.find {username: new RegExp("#{a}")+'i', 'username name avatar'}