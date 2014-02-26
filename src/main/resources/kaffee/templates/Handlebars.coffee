handlebars = require "lib/templates/Handlebars"

LOG = require "vertx/console"
vertx  = require "vertx"
fs     = vertx.fileSystem

PathAdjuster = require 'kaffee/utils/PathAdjuster'

render = (templateFile, data, done = null ) ->
  templateFileAdjusted = PathAdjuster.adjust templateFile
#  LOG.log "Handlebars: rendering #{templateFile} (#{templateFileAdjusted}) with data: " + JSON.stringify data

  fs.readFile templateFileAdjusted, (err, res) ->
    if (!err)
      template = handlebars.compile res.toString()
      result = template(data)
      done null, result
    else
      done err, null

module.exports = handlebars
module.exports.render = render;