http = require "vertx/http"
template = require "kaffee/Template"
container = require "vertx/container"
LOG = container.logger

http.HttpServerRequest::render = (templateFile, data, statusCode = 200) ->
  LOG.info "HttpServerRequest::render"
  response = @response
  template.render templateFile, data, (err, result) ->
    if !err
      response.statusCode statusCode
      response.end result
    else
      response.statusCode 500
      response.end JSON.stringify err

http.HttpServerRequest::renderAsJson = (data, statusCode = 200) ->
  LOG.info "HttpServerRequest::renderAsJson"
  response = @response
  response.statusCode statusCode
  jsonStr = JSON.stringify data
  response.end jsonStr
