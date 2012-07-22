class DevRouter extends Routerious

  routes:
    'p/:element/:view/:partial'  : 'showPartial'
    't/:template' : "showTemplate"

  showPartial: (element, view, partial) =>
    @__prepareView("#{view}/partials/#{partial}",{el: element})

  showTemplate: (template) =>
    console.log template
    @__prepareView("Utils/Templater", {template: template, el: 'body'})


exports.init = ->
  new DevRouter()