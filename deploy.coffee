fs = require 'fs'
{exec} = require 'child_process'

console.log "Initializing deploy process..."

exec 'stop playlifestyle', (error, stdout, stderr) ->
  console.log "Stopping playlifestyle..."
  console.log stdout, stderr

  unless error
    exec 'sudo -u ubuntu git pull', (error, stdout, stderr) -> 
      console.log "Pulling repository..."
      console.log stdout, stderr

      unless error
        exec 'npm i', (error, stdout, stderr) -> 
          console.log "Updating dependencies..."
          console.log stdout, stderr

          unless error
            exec 'start playlifestyle', (error, stdout, stderr) -> 
              console.log "Starting playlifestyle..."
              console.log stdout, stderr
              unless error
                console.log "We're ready boy!"
              else
                console.log "failed! start playlifestyle"
                console.log error
          else
            console.log "failed! npm i"
            console.log error
      else
        console.log "failed! git pull"
        console.log error
  else
    console.log "failed! stop playlifestyle"
    console.log error

s3client = require('./config/deploy').getClient()

fs.readdir('./client/static/assets/main', (err, files) =>
  if files
    for f in files
      console.log "Queued to upload #{f}"
      s3client.putFile("./client/static/assets/main/#{f}", "assets/main/#{f}", (err, result) =>
        if err then throw err
        if 200 is result?.statusCode then console.log "File #{f} uploaded to Amazon S3"
        else console.log "Failed to upload file #{f} to Amazon S3"
      )
)

fs.readdir('./client/static/images', (err, files) =>
  if files
    for f in files
      console.log "Queued to upload #{f}"
      s3client.putFile("./client/static/images/#{f}", "images/#{f}", (err, result) =>
        if err then throw err
        if 200 is result?.statusCode then console.log "File #{f} uploaded to Amazon S3"
        else console.log "Failed to upload file #{f} to Amazon S3"
      )
)