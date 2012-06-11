# Init routers
window.MainRouter = require('/routers/MainRouter').init()

# Then start Backbone History
Backbone.history.start
    pushState: true

