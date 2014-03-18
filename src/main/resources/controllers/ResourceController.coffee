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
container = require "vertx/container"
_ = require "kaffee/utils/lodash"
adjuster = require "kaffee/utils/PathAdjuster"

LOG = container.logger
_mappings = []


class ResourceController
  constructor: ()->
    LOG.info "Init ResourceController"

  handle: (req)->

    path = req.path()
    LOG.info "Requesting [#{path}] " + JSON.stringify _mappings
    LOG.info "ResourceController.this: " + JSON.stringify this
    matched = _.find _mappings, (mapping) ->
      path.indexOf mapping.prefix >= 0


    filePath = path.substr matched.prefix.length
    filePath = "#{matched.docRoot}/#{filePath}"

    absPath = adjuster.adjust filePath

    if absPath?
      req.response.sendFile absPath
    else
      @notFound(req)

  addMapping: (pattern, docRoot) ->
    docRoot = "#{docRoot}/" unless docRoot.substr(-1,1) == "/"
    LOG.info "Adding mapping [#{pattern}] -> [#{docRoot}]"
    _mappings.push {prefix: pattern, docRoot: docRoot}

    LOG.info "Mapped: " + JSON.stringify _mappings

module.exports = ResourceController