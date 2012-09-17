# Require Mongoose
mongoose  = require('mongoose')
# put the Schema simple
Schema    = mongoose.Schema

# Define Message Schema
MessageSchema = new mongoose.Schema
  from: Schema.ObjectId
  to: Schema.ObjectId
  title: String
  body: String
  read: Boolean
  date_sent: Date
  date_read: Date

# Define the Schema
InboxSchema = new mongoose.Schema
  #username inbox belongs to
  user: Schema.ObjectId

  messages: [MessageSchema]

# Define the Model
mongoose.model('Inbox', InboxSchema)

# Export the schema and the model separately
module.exports.schema = InboxSchema
module.exports.model = mongoose.model('Inbox')