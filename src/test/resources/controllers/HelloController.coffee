class HelloController
  index: (req) ->
    req.response.end("<h1>Hello #{req.params().get 'name'}</h1>")


module.exports = HelloController