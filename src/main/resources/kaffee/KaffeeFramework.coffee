vertx     = require 'vertx'
container = require 'vertx/container'
logger    = require 'vertx/console'
logger.log JSON.stringify container.config
# create routeMatcher
RouteBuilder = require 'kaffee/RouteBuilder'
builder = new RouteBuilder();
builder.build (routeMatcher) ->
  logger.log "Build routeMatcher done"
  logger.log "create http server"
  server    = vertx.createHttpServer()

  server.requestHandler routeMatcher  # build the routeMatcher and map routes with controllers
  # more configuration

  listenPort = 8080
  listenHost = 'localhost'
  logger.log "Start listening on #{listenHost}:#{listenPort}"
  server.listen listenPort, listenHost

KaffeeFramework = {}

#conf =
#  routes: ["dev.coffee", "simple.js"]
#  controllers:
#    includes: ["*"]
#    excludes: ["xxx"]

KaffeeFramework.start = (conf) ->
  # startup the KaffeePlatform



# watch for changes on controllers or routes
#ArtefactMonitor = require 'ArtefactMonitor.coffee'
#monitor = new ArtefactMonitor()

#monitor.controllers 'controllers'
#monitor.routes 'routes'



# rebuild and/or remap routes & controllers
module.exports = KaffeeFramework