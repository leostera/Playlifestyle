exports = {
  
  killCollections: =>
    _.forEach collections, (collection) ->
      if collections.killMe is yes
        collection.kill()
        collection.killMe = no

  refetchCollections: =>
    _.forEach collections, (collection) ->
      collection.fetch()

  refetchModels: =>
    _.forEach models, (model) ->
      model.fetch()

  }