class DevRouter extends Routerious

  routes:
    'p/:element/:view/:partial'  : 'showPartial'

  showPartial: (element, view, partial) =>
    view = @__prepareView("#{view}/partials/#{partial}",{el: element})


exports.init = ->
  new DevRouter()