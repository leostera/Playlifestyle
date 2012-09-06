module.exports.getClient = () ->
  knox = require('knox')
  knox.createClient({
      key: 'AKIAJWOLAES7KPWHKGWA'
    , secret: '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'
    , bucket: 'playlifestyle'
  })
