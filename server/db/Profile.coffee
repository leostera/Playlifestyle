# Require Mongoose
mongoose      = require('mongoose')

# Define the Schema
ProfileSchema = new mongoose.Schema

  name:
    first: String
    initial: String
    last: String

exports.schema = ProfileSchema