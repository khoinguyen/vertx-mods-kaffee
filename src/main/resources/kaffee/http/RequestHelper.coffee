http = require "vertx/http"
template = require "kaffee/Template"

http.HttpServerRequest::render = (templateFile, data, statusCode = 200) ->
  response = @response
  template.render templateFile, data, (err, result) ->
    if !err
      response.statusCode statusCode
      response.end result
    else
      response.statusCode 500
      response.end JSON.stringify err

