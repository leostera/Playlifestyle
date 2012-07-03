class DevRouter extends Routerious

  routes:
    'p/:element/:view/:partial'  : 'showPartial'
    'v/:view' : 'view'

  showPartial: (element, view, partial) =>
    view = @__prepareView("#{view}/partials/#{partial}")    
    $("#{element}").html view.render()

exports.init = ->
  new DevRouter()