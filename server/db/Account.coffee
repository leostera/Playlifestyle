# Require Mongoose
mongoose      = require('mongoose')
mongooseTypes = require('mongoose-types')
mongooseTypes.loadTypes(mongoose,'email')

# Define the Schema
AccountSchema = new mongoose.Schema

  name: String
  
  pass:
    type: String
    default: "1234"

  email:
    type: mongoose.SchemaTypes.Email
    unique: true

  birthdate: Date

  hometown: String

  located:
    type: Boolean
    default: no

  location:
    lat: String
    lon: String

  profile: [require('./Profile').schema]

# Plugins
AccountSchema.plugin(mongooseTypes.useTimestamps)

# Define the Model
mongoose.model('Account', AccountSchema)

exports.schema = AccountSchema
exports.model = mongoose.model('Account')