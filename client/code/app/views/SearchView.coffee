class IndexView extends Backbone.View

  template: ss.tmpl['views-search']

  initialize: (options) =>
    @$el = $(options.el)
    @query = options.query
    @render()
    @$el = $('#main-content')
    @search()

  render: =>    
    @$el.html @template.render {}
    
    @

  search: (query=@query) =>
    ss.rpc('content.omniSearch',query, (res) =>
      if res.status is yes
        _.each res.results, (r) =>
          @showResult r
      else

    )
  
  showResult: (r) =>
    @$('#results').append ss.tmpl['partials-searchResult']

exports.init = (options={}) ->
  new IndexView(options)