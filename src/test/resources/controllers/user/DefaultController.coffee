class DefaultController
  index: (req)->
    req.response.end("user/DefaultController.index")


module.exports = DefaultController