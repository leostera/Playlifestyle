#     Routerious.coffee 0.1.1

#     (c) 2010-2012 Leandro Ostera.
#     Routerious may be freely distributed under the MIT license.
#     For all details and documentation:
#     http://github.com/leostera/Routerious


#  Routerious
## ----------

###
#  Routerious is an extended Backbone.Router that includes utility functions
#  making it a good choice for a View-Master or Collection-Master Router
#  or even a mixup of those.
#
#  It also includes functionality for Router-wide model handling (such as a
#  global or router-wide user model or session model)
#
#  Ro...ro...routerious
### 

class Routerious extends Backbone.Router

  ###
  Attributes
  ###
  collections: []
  views: []
  models: []

  ###
  Utility functions
  ###

  # __prepareView( view )
  __prepareView: (viewName, options={kill_all: yes}, killMe=yes) =>
    # clean unused views
    if options?.kill_all then @__killViews()
    # prepare clean view object
    view = {}
    _.extend view, require('../views/'+viewName).init(options), {killMe: killMe}
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
  __killCollections: =>
    _.forEach collections, (collection) ->
      if collections.killMe is yes
        collection.kill()
        collection.killMe = no

  __refetchCollections: =>
    _.forEach collections, (collection) ->
      collection.fetch()

  __refetchModels: =>
    _.forEach models, (model) ->
      model.fetch()