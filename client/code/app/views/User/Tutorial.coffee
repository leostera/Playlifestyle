class TutorialView extends Backbone.View

  templates:
    nav: ss.tmpl['tutorial-nav']
    full: ss.tmpl['tutorial-content-full']
    steps: [
      ss.tmpl['tutorial-partials-step-0']
      ss.tmpl['tutorial-partials-step-1']
      ss.tmpl['tutorial-partials-step-2']
      ss.tmpl['tutorial-partials-step-3']
      ss.tmpl['tutorial-partials-step-4']
      ss.tmpl['tutorial-partials-step-5']
      ss.tmpl['tutorial-partials-step-6']
    ]

  render: =>
    $('#full').html @templates.full.render {}
    $('#side').hide()
    $('#main').hide()
    $('#nav').html @templates.nav.render {}
    @.el

  start: =>
    @step = 0
  
exports.init = (options) ->
  new TutorialView(options).render().start()
  