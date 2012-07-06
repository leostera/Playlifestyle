# Init routers
window.UserRouter = require('/routers/UserRouter').init()
window.MainRouter = require('/routers/MainRouter').init()
# only for development purposes
window.DevRouter = require('/routers/DevRouter').init()

# Then start Backbone History
Backbone.history.start
    pushState: true

