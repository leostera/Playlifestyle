module.exports.Alphabetic = (string) ->
  #check for only alphabetic+whitespaces instead of not only whitespace
  /^[a-zA-Z]{1}[a-zA-Z ]+$/.test string

module.exports.Email = (email) ->
  #ok here use ^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$
  /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$/.test email

module.exports.Date = (date) ->
  not isNaN Date.parse 

module.exports.NotEmpty = (string) ->
  /^[ ]*/.test string