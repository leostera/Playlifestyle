credentials = module.exports.credentials = {
      key: 'AKIAJWOLAES7KPWHKGWA'
    , secret: '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'
    , bucket: 'playlifestyle'
  }

module.exports.getClient = () ->
  require('knox').createClient(credentials)
