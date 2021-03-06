vertx = require 'vertx'
fs    = vertx.fileSystem
LOG   = require 'vertx/console'

vertxPathAdjuster = org.vertx.java.core.file.impl.PathAdjuster
Thread = java.lang.Thread

PathAdjuster =
  adjust: (path, done = null) ->
    defaultAdjusted = vertxPathAdjuster.adjust __jvertx, path

    LOG.log "Adjusted #{path}: #{defaultAdjusted} "
    return defaultAdjusted if fs.existsSync defaultAdjusted
    cl = Thread.currentThread().getContextClassLoader();

    return fileUrl = cl.getResource(path)

    # TODO use vertx_classpath.txt to resolve path
    guesses = [
      "#{path}",
      "src/main/resources/#{path}",
      "lib/#{path}",
    ]
    cwd  = new java.io.File(".").getCanonicalPath() + "/"

    LOG.log "CWD: #{cwd}"
    LOG.log "Guess list: " + JSON.stringify guesses
    adjusted = (p for p in guesses when fs.existsSync p)
    LOG.log "Best matched: " + JSON.stringify adjusted
    return adjusted[0] if adjusted.length > 0



module.exports = PathAdjuster