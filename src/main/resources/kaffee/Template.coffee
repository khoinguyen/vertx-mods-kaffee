Template = {}

extractFileExtension = (templateFile) ->
  templateFile.substr((templateFile.lastIndexOf ".") + 1)

resolveEngine = (templateFile) ->
  ext = extractFileExtension templateFile
  return Template._engineMappings[ext] if Template._engineMappings[ext]?

  return Template.defaultEngine


Template.render = (templateFile, data, done) ->
  engine = resolveEngine templateFile

  engine.render templateFile, data, done

Template.handlebars = require 'kaffee/templates/Handlebars'

### Default template engine ###
Template._engineMappings =
  'html': Template.handlebars

Template.defaultEngine = Template.handlebars

Template.addEngine = (extension, engine)->
  ###
    Map extension to template engine
  ###
  Template._engineMappings[extension] = engine


module.exports = Template