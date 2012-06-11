# Stablish a base for different validations using regexes
#
# Use should be something like:
#
#    v = require('../utils/Validations')
#    b = v.check(email, {type: 'email', required: true, max:200} ) # returns yes or no
# or
#    b = v.check([
#         [email1, {type: 'email', required: true, max:200}],
#         [email1, {type: 'email', required: true, max:200}],
#         [email1, {type: 'email', required: true, max:200}],
#         [email1, {type: 'email', required: true, max:200}],
#         [email1, {type: 'email', required: true, max:200}],
#         [email1, {type: 'email', required: true, max:200}],
#      ])
#     # returns yes or an array with the id of the failed emails
#     # and a list of errors
#     # like this:
#     #       [ 2 , ["Not a valid e-mail", "Required field is empty"] ]
#     #   Second email was empty and invalid.      
#         
#