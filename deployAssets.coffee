s3client = require('./config/storage').getClient()
fs = require('fs')

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