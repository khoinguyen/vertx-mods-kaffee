###
Copyright 2014 khoinguyen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###

vertx     = require 'vertx'
container = require 'vertx/container'
logger    = container.logger

JsonObject = org.vertx.java.core.json.JsonObject

conf = new JsonObject(JSON.stringify container.config)

kaffeeConf = conf.getObject("kaffee") ? new JsonObject()

logger.debug kaffeeConf


# create routeMatcher
RouteBuilder = require 'kaffee/RouteBuilder'
builder = new RouteBuilder();
KaffeeFramework = {}

builder.build (routeMatcher) ->
  logger.debug "Build routeMatcher done"
  logger.info "Create http server"
  server    = vertx.createHttpServer()

  server.requestHandler routeMatcher  # build the routeMatcher and map routes with controllers
  # more configuration
  httpConf = kaffeeConf.getObject("http") ? new JsonObject()

  listenPort = httpConf.getNumber "port", 8080
  listenHost = httpConf.getString "host", 'localhost'

  logger.info "Start listening on #{listenHost}:#{listenPort}"
  server.listen listenPort, listenHost




KaffeeFramework.start = (conf) ->
  # startup the KaffeePlatform


module.exports = KaffeeFramework