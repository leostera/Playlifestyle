# Require Mongoose
mongoose      = require('mongoose')
#mongooseTypes = require('mongoose-types')
#mongooseTypes.loadTypes(mongoose,'email')

# Define the Schema
AccountSchema = new mongoose.Schema

  name: String
  
  password:
    type: String
    default: "1234"

  email:
    #type: mongoose.SchemaTypes.Email
    type: String
    unique: true

  birthdate: Date

  hometown: String

  located:
    type: Boolean
    default: no

  location:
    ip: String
    str: String
    lat: String
    lon: String

  profile: [require('./Profile').schema]

# Plugins
# AccountSchema.plugin(mongooseTypes.useTimestamps)

# Define the Model
mongoose.model('Account', AccountSchema)

module.exports.schema = AccountSchema
module.exports.model = mongoose.model('Account')