# Require Mongoose
mongoose  = require('mongoose')
# put the Schema simple
Schema    = mongoose.Schema
# Require Mongoose Types for the Email SchemaType
#mongooseTypes = require('mongoose-types')
# Load the Email SchemaType
#mongooseTypes.loadTypes(mongoose,'email')

# Define Follow Schema
FollowSchema = new mongoose.Schema
  id: Schema.ObjectId

  username:
    type: String
    lowercase: true
    trim: true
    
  avatar:
    url: String
    use_gravatar: Boolean

# Define the Schema
AccountSchema = new mongoose.Schema

  #username is a unique, lowercase, trimmed string
  username: 
    type: String
    lowercase: true
    trim: true
    unique: true
  
  #password is not unique, and it's a string representing a hash
  password: String

  #email is also unique, lowercase and trimmed, ain't String but Email
  email:
    type: String
    #type: mongoose.SchemaTypes.Email
    unique: true
    lowercase: true
    trim: true

  #joindate is a Dat
  joindate:
    type: String
    default: (new Date()).toDateString()

  #birthdate is a Date
  birthday: Date
    #we should add range checking here

  #hometown is a String, but could be latLon for the hometown
  hometown: String

  #avatar is a url for the avatar or the url for the gravatar
  avatar: String

  #location is mixed. here we can put as many info as we can get
  location: {}
  ###
  For now this is what we are including within the location:
    location.city
    location.region
    location.country
    location.country_code
  ###

  #gender is a string.
  gender: String

  #name is mixed
  name:
    first: String
    last: String

  #bio is string
  bio: String

  #following is an array of other users ids
  following: [FollowSchema]
  followers: [FollowSchema]


# Define the Model
mongoose.model('Account', AccountSchema)

# Export the schema and the model separately
module.exports.schema = AccountSchema
module.exports.model = mongoose.model('Account')