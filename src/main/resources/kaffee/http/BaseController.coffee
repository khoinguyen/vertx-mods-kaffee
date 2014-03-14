template = require "kaffee/Template"
adjuster = require "kaffee/utils/PathAdjuster"
LOG = require "vertx/console"

class BaseController
#  index: ()->
#    LOG.log "BaseController.index"

  render: (templateFile, data, done) ->
    template.render templateFile, data, done

  notFound: (req)->
    @noMatchHandler req

  noMatchHandler: (req) ->
    req.response.statusCode 404
    err404 = adjuster.adjust "webapp/err/404.html"
    if err404?
      req.response.sendFile err404
    else
      req.response.end "<h1>Not Found</h1>"


module.exports = BaseController

