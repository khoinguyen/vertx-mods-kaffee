---
layout: page
title: KaffeeJS - Vert.x Web Application Framework
---

### Introduction	
KaffeeJS is a minimal [Vert.x](http://vertx.io) web application framework, provide simple set of features for CoffeeScript/JavaScript developers to build single and multi-pages web applications.

KaffeeJS built with "convention over configuration" in mind, but advanced developer still have ability to do deeper customization.

### Quick-start guide
You can start with KaffeeJS by clone the [KaffeeJS sample project](http://github.com/khoinguyen/kaffee-sample)

{% highlight sh %}
$ git clone https://github.com/khoinguyen/kaffee-sample.git my-project
$ cd my-project
$ ./gradlew runMod
{% endhighlight %}

The web application shall start on port *8080*. Open your browser and point to [http://localhost:8080/](http://localhost:8080/)

That's it, [KaffeeJS]({{site.repoUrl}}) is up.

### Roadmap

1. Version 0.0.x: Basic framework to develop a simple web application, included
	* Route configuration
	* Controller
	* Template engines
	* Integrate mongo-persistor
	* Logging mechanism
	* Configuration
2. Version 0.1.x: Integrate with client side development framework like [AngularJS](http://angularjs.org/), [Foundation CSS](http://foundation.zurb.com) and capbility to do multi-module application.
3. Version 1.x: Production deployment features (TBD)

### Got problem?
Please report your issues on [GitHub project tracking](https://github.com/khoinguyen/vertx-mods-kaffee/issues)
