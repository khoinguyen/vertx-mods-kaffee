Template = {}
_exports = exports ? this

Template.render = (templateFile, data, done = null) ->
  ###
   TODO render the template templateFile with appropriate engine based on the extension
   if done is null, render will blocking and return the template
   if done is function, we pass the templateFile and data to eventBus, call done callback when complete
  ###

Template.handlebars = require 'kaffee/templates/Handlebars'

# Default template engine
Template._engineMappings =
  'html': Template.handlebars

Template.addEngine = (extension, engine)->
  ###
    Map extension to template engine
  ###
  Template._engineMappings[extension] = engine


module.exports = Template