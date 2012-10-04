class IndexView extends Backbone.View

  template: ss.tmpl['views-search']

  initialize: (options) =>
    @$el = $(options.el)
    @query = options.query
    @render()
    @$el = $('#main-content')
    @search(@query)

  render: =>    
    @$el.html @template.render { query: @query }
    
    @

  search: (query=@query) =>
    ss.rpc('content.omniSearch.search',query, (res) =>
      console.log res
      if res.status is yes
        @$('#results').html('')
        _.each res.results, (r) =>
          @showResult r
      else
        @$('#results span h3').html('We found nothing in our databases. Try something else :)')

    )
  
  showResult: (r) =>
    @$('#results').append ss.tmpl['partials-searchResult'].render { user: r }

exports.init = (options={}) ->
  new IndexView(options)