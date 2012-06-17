module.exports = (creds, fn) ->

  valid = require('../../utils/Validators')
  email = require("../../utils/Email")

  @error =
    user: yes
    email: yes
    birth: yes
    hometown: yes

  #check for only alphabetic+whitespaces instead of not only whitespace
  if valid.Alphabetic(creds.user)
    @error.user = no
  else
    @error.user = "Invalid username"

  unless email.isTaken(creds.email) and email.isValid(creds.email)
      @error.email = no
  else
    @error.email = "Email already in use"

  # check that is more tan 0 in length (the field)
  # that it's a valid date by parsing it
  # and that has no
  if valid.Date(creds.date)
    @error.birth = no
  else
    @error.birth = "Invalid birth date"

  #check for only alphabetic+whitespaces instead of not only whitespace
  if valid.Alphabetic(creds.hometown)
    @error.hometown = no
  else
    @error.hometown = "Invalid city name"

  if @error.user is no and @error.email is no and @error.hometown is no and @error.birth is no
    UserModel = require('../../models/Account').model
    newUser = new UserModel
      name: creds.user
      email: creds.email
      hometown: creds.hometown
      birth: creds.birth

    newUser.save( (err) -> 
        fn(err,newUser)
      )

  else
    fn(@error)