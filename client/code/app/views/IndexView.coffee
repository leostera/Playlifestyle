class IndexView extends Backbone.View

  template: ss.tmpl['views-index']

  initialize: =>
    @render()

    #not jquery chipchattery, real bindings and stuff
    @partials.login.on 'registration:begin', @partials.register.begin
    @partials.register.on 'login:begin', @partials.login.begin

  render: =>    
    @$el.html @template.render {}
    @partials =
      login: require('./partials/LoginPartial').init({el: @$('section#login')})
      register: require('./partials/RegisterPartial').init(el: @$('section#register'))

    @
    
exports.init = (options={}) ->
  new IndexView(options)