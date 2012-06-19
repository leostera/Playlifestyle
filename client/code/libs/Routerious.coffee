class Routerious extends Backbone.Router

  collections: []
  views: []
  models: []

  ###
  Utility functions
  ###

  # __prepareView( view )
  __prepareView: (view, options=undefined, killMe=yes) =>
    @__killViews()
    view = require('../views/'+view).init(options)
    view.killMe = killMe
    @views.push view
    _.last @views

  # __killViews
  ## Takes care of removing all the views and unbinding all events
  ## when rerouting to a new path
  __killViews: (options={preserve_dom: true}) =>
    _.forEach @views, (view) =>
      if view.killMe is yes
        view.kill(options)
        view.killMe = no
      @views.pop view

  # __killCollections
  ## Kills all the collections, just that easy.
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