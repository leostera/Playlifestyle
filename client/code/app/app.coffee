# Init routers
# DevRouter for development purposes
window.DevRouter = require('/routers/DevRouter').init()
window.MainRouter = require('/routers/MainRouter').init()

# Then start Backbone History
Backbone.history.start
    pushState: true

