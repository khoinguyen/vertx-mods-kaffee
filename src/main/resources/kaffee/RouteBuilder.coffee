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

vertx  = require 'vertx'
container = require 'vertx/container'
logger = container.logger

root = this;

class RouteBuilder
  constructor: (@mainRouteDef = "conf/routes", @controllerDir = "controllers", @filter = ".*\.(js|coffee)") ->
    @controllerClasses = {}
    @routeDefs = {}
    vertx = require 'vertx'
    @logger = require 'vertx/console'
    @logger.log("Loading RouteBuilder")
    @fs    = vertx.fileSystem
    @routeMatcher = new vertx.RouteMatcher()

  importRoute: (importDef) ->
    router = root.router
    router.logger.log "Import route def '#{importDef}'"
    router.loadFile "conf/#{importDef}"

  get: (route, controllerClass, action) ->
    root.router.handle "get", route, controllerClass, action



  handle: (verb, route, controllerClass, action = 'index') ->
    if @routeDefs["#{verb}|#{route}"]?
      @logger.log("Ignore defined route: #{verb.toUpperCase()} #{route}.")
      return

    @routeDefs["#{verb}|#{route}"] = Date.now()

    msg = verb.toUpperCase() + " #{route} -> #{controllerClass}.#{action}"
    controller = @load controllerClass
    if @routeMatcher[verb]? and controller?[action]?
      @routeMatcher[verb] route, controller[action]
      @logger.log("Mapping #{msg}")
    else
      @logger.log("Failed to load #{msg}")

  load: (controllerClass) ->
    if ! @controllerClasses[controllerClass]?
      @logger.log "Loading #{@controllerDir}/#{controllerClass}"
      clazz = require("#{@controllerDir}/#{controllerClass}")
#      @logger.log JSON.stringify clazz
      if clazz instanceof Function
#        @logger.log "#{controllerClass} is instanceof Function"
        @controllerClasses[controllerClass] = new clazz() # instanable class
      else
        @logger.log "#{controllerClass} is object"
        @controllerClasses[controllerClass] = clazz # object with static function
    else
      @controllerClasses[controllerClass]

#  locateDevelopmentDirectory: (directory) ->
#    pAdjuster = org.vertx.java.core.file.impl.PathAdjuster
#    moduleDir = pAdjuster.adjust(__jvertx, ".")
#
  loadFile: (fileToLoad)->
    LOG = @logger
    cwd  = new java.io.File(".").getCanonicalPath()

    locations = [
      fileToLoad,
      "#{cwd}/#{fileToLoad}",
      "#{cwd}/src/main/#{fileToLoad}",
      "#{cwd}/src/main/resources/#{fileToLoad}"
    ]
    fs = @fs
    for file in locations
      do (file) ->
        LOG.log "Try to loading #{file}"
#        if fs.existsSync file
        try
          load file
          LOG.log "Loaded #{file}"
        catch err
#          LOG.log "Fai loading #{file}: #{err}"

  build: (done) ->
    LOG = @logger
    router = root.router = this

    # expose DSL to load mainRootDef
    exposableFunctions = ["get", "post", "put", "delete", "head", "options", "trace", "connect", "patch", "all",
                          "getWithRegEx", "postWithRegEx", "putWithRegEx", "deleteWithRegEx", "headWithRegEx",
                          "optionsWithRegEx", "traceWithRegEx", "connectWithRegEx", "patchWithRegEx", "allWithRegEx"]

    for func in exposableFunctions
      do (func)->
        root[func] = (route, controllerClass, action) ->
          root.router.handle func, route, controllerClass, action

    root["importRoute"] = this["importRoute"];

    cwd  = new java.io.File(".").getCanonicalPath() + "/"

    LOG.log "Building Routes... CWD: #{cwd}"

    @loadFile "#{@mainRouteDef}.js"
    @loadFile "#{@mainRouteDef}.coffee"

    router.routeMatcher.noMatch (req) ->
      req.response.statusCode 404

      if router.fs.existsSync "../../www/err/404.html"
        req.response.sendFile("../../www/err/404.html")
      else
        req.response.end "<h1>Not Found</h1>"

    done router.routeMatcher

module.exports = RouteBuilder
