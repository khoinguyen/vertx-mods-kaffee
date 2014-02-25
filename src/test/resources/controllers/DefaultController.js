var DefaultController = {
    index: function(req) {
        req.response.end("<h1>hello world!</h1>")
    },
    hello: function(req) {
        req.response.end("<h1>hello world 2!</h1>")
    }
}

module.exports = DefaultController;