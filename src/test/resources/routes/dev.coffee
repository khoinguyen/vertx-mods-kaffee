#          Route
router.get "/",                     'DefaultController',            'index'
router.get "/hello/:name",          "DefaultController",            'hello'
router.get "/user/:id",             "user/DefaultController"