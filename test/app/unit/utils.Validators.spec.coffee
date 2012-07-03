validators = require('./app/utils').Validators

describe "App/Utils/Validators", ->

  describe "for Emails", ->

    it "matches valid emails", ->
      validators.checkEmail("leostera@gmail.com").should.be(true)