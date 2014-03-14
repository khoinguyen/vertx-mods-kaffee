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
_ = require "kaffee/utils/lodash"
adjuster = require "kaffee/utils/PathAdjuster"

BaseController = require "kaffee/http/BaseController"

root = this;



class RouteBuilder
  constructor: (@mainRouteDef = "conf/routes", @controllerDir = "controllers") ->
    @controllerClasses = {}
    @routeDefs = {}
    vertx = require 'vertx'
    @logger = logger
    @logger.debug("Loading RouteBuilder")
    @fs    = vertx.fileSystem
    @routeMatcher = new vertx.RouteMatcher()

  importRoute: (importDef) ->
    router = root.router
    router.logger.debug "Import route def '#{importDef}'"
    router.loadFile "conf/#{importDef}"

  resource: (prefix, docRoot) ->
    router = root.router
    router.logger.debug "Resource [#{prefix}] -> [#{docRoot}]"
    controller = router.load "ResourceController"
    controller.addMapping prefix, docRoot

    router.handle "getWithRegEx", "#{prefix}/.*", "ResourceController", "handle"

  handle: (verb, route, controllerClass, action = 'index') ->
    if @routeDefs["#{verb}|#{route}"]?
      @logger.debug("Ignore defined route: #{verb.toUpperCase()} #{route}.")
      return

    @routeDefs["#{verb}|#{route}"] = Date.now()

    msg = verb.toUpperCase() + " #{route} -> #{controllerClass}.#{action}"
    controller = @load controllerClass
    @logger.debug "Controller contains request action(#{action}): #{controller?[action]?}"
    @logger.debug "RouteMatcher contains request verb #{verb}: #{@routeMatcher[verb]?}"
    if @routeMatcher[verb]? and controller?[action]?
      @logger.debug("Mapping #{msg}")
      @routeMatcher[verb] route, _.bind(controller[action], controller)
      @logger.debug("Mapped #{msg}")
    else
      @logger.debug("Failed to load #{msg}")

  load: (controllerClass) ->
    if ! @controllerClasses[controllerClass]?
      @logger.debug "Loading #{@controllerDir}/#{controllerClass}"

      clazz = require("#{@controllerDir}/#{controllerClass}")

      if clazz instanceof Function
        @logger.debug "#{controllerClass} is instanceof Function"
        _.assign clazz::, BaseController::
        theObject = new clazz(); # instanable class

        @logger.debug "Class contains: " + JSON.stringify theObject
        @controllerClasses[controllerClass] = theObject
      else
        @logger.debug "#{controllerClass} is object"
        theObject = _.assign clazz, BaseController::
        @controllerClasses[controllerClass] = theObject # object with static function
    else
      @controllerClasses[controllerClass]

  loadFile: (fileToLoad)->
    LOG = @logger

    absPath = adjuster.adjust fileToLoad
    if absPath?
      load fileToLoad
    else
      LOG.warn "File [#{fileToLoad}] not found in classpath."

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
    root["resource"] = this["resource"];

    cwd  = new java.io.File(".").getCanonicalPath() + "/"

    LOG.debug "Building Routes... CWD: #{cwd}"

    @loadFile "#{@mainRouteDef}.js"
    @loadFile "#{@mainRouteDef}.coffee"

    router.routeMatcher.noMatch BaseController::noMatchHandler

    done router.routeMatcher

module.exports = RouteBuilder
