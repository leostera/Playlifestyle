fs = require 'fs'
{spawn, exec} = require 'child_process'

option '-e', '--environment [ENVIRONMENT_NAME]', 'set the environment for `run`'
task 'run', 'Start the application', (options) ->

  options.environment or= 'production'
  process.env['SS_ENV'] = options.environment
  process.env['SS_PACK'] = 1 #Always force repack
  coffee = spawn 'coffee', ['run']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()


task 'deploy', "Deploy to S3", ->

  s3client = require('./config/deploy').getClient()

  fs.readdir('./client/static/assets/main', (err, files) =>
    for f in files
      console.log "Queued to upload #{f}"
      s3client.putFile("./client/static/assets/main/#{f}", "assets/main/#{f}", (err, result) =>
        if err then throw err
        if 200 is result?.statusCode then console.log "File #{f} uploaded to Amazon S3"
        else console.log "Failed to upload file #{f} to Amazon S3"
      )
  )

  fs.readdir('./client/static/images', (err, files) =>
    for f in files
      console.log "Queued to upload #{f}"
      s3client.putFile("./client/static/images/#{f}", "images/#{f}", (err, result) =>
        if err then throw err
        if 200 is result?.statusCode then console.log "File #{f} uploaded to Amazon S3"
        else console.log "Failed to upload file #{f} to Amazon S3"
      )
  )

