class DevRouter extends Routerious

  routes:
    'p/:partial/:element'  : 'dummy'

  dummy: (partial,element) =>
    view = @__prepareView("Auth/partials/#{partial}")
    console.log view
    $("##{element}").html view.render()

exports.init = ->
  new DevRouter()