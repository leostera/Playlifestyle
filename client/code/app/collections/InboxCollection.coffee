class InboxCollection extends Backbone.Collection
  model: require('../models/MessageModel').model

  initialize: =>
    
    @