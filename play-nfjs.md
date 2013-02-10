h1. Having fun with Play Framework

_Nilanjan Raychaudhuri, Typesafe_

*Play is a web framework that brings back fun to web development for Java and Scala developers. I know what you are thinking -* *{_}Oh no another web framework?_* *Before you turn to the next article give me 5 minutes to make a case where if you are a web developer building web applications for the JVM you cannot avoid Play framework. I am pretty sure it will impress you.*

*So what is wrong with building web applications for the JVM?* Its not fun anymore. Something is missing from the experience. The type of web applications we are building has changed. Todays web applications are integrating more real-time data, it has more scalability requirements and needs to be more user-friendly. But the web frameworks we use to build web applications for the JVM hasn't improved that much.

*So what do we need?* We need a framework that makes the web development fun and easy by combining the new frontend technologies like HTML5, LESS and CoffeeScript with backend tools that provides scalability and development ease so you can focus on solving the business problem using the tools that meets todays demand. The play framework combines the best tools from Java/Scala world with the latest frontend technologies so you can be productive from the get go. The play framework \[1\] is a complete web development stack to take care of your web 3.0 application requirements. I think an example would be handy right about now. The best way to explore Play framework is to build an application using it.It is also an opportunity for you to find out what Play offers.

In this article we will build a small sample application called find_events using REST API from Last.fm \[2\] that finds events/concerts for various artists(See Figure 1). In the process we will explore the framework and learn. If you just want to follow along without getting your hand dirty you can access the codebase from github \[3\].

!https://raw.github.com/nraychaudhuri/find_events/master/images/home.png!
{center}Figure 1: Home screen of the find_events application
{center}
Lets rock and roll\!

h2. Installing and running Play

To install Play framework simply follow the setup guide from the play framework \[4\] website. If you have homebrew then you can use the following command to install play framework to your local environment:
{code}
brew install play
{code}
After the installation process to check whether you have the play command available use the _play help_ from terminal shell.
{info:title=Play provides fast feedback}
Play framework is an MVC framework written in Scala. It provides both Scala and Java API to the developers. You can mix both Java and Scala to build your application. One of the key feature of Play framework is type-safety. It uses Scala compiler to type-check everything so that you can catch errors earlier in the process. It also provides fast turnaround where you can edit any file in your application and refresh your browser to see the results. No more lengthy build deploy cycle(I know you don't like it). The Play framework is very similar to Ruby on Rails but fast, type safe and runs on the JVM.
{info}
Now we are ready to take it for a spin. The easiest way to create an application using play is to use "play new" command.
{code}
play new find_events
{code}
This command will take you through a couple of interactive steps to gather information(see figure 2) about the project before it creates the project structure for you. For this article we will select Scala as our language of choice but you can still mix Java code to the project whenever you need.

!https://raw.github.com/nraychaudhuri/find_events/master/images/create_project.png!
{center}Figure 2: steps for creating the project
{center}
To run the application change directory to _find_events_ and execute the following command:
{code}
play run
{code}
Now if you point your browser to [http://localhost:9000] you will see the welcome page of our application. Congratulations you just created your first play application without writing any single line of code(See figure 3).

!https://raw.github.com/nraychaudhuri/find_events/master/images/welcome-page.png!
{center}Figure 3: Welcome page
{center}
The welcome page contains enough information to get you started with how the page is rendered, various components of Play, setting up an IDE etc. If you are seeing this page for the first time I would recommend that you spend some time on it. If you prefer to use an IDE to build this application you could use one of the commands mentioned in the home page. The following command will generate the project files for eclipse:
{code}
play eclipse
{code}

h2. Writing our first controller action

Before we write our first controller action we need to understand how requests are served by Play framework. Play framework ships with its own embedded HTTP server that works as a network interface with the clients. When the client sends an HTTP request to a Play application the request is handled by the embedded HTTP server and then the request is forwarded to Play framework to generate the appropriate response. And finally the server sends the response back to the client.
{info:title=Play is built for asynchronous web programming}
Non-blocking IO is the name of the game these days. The philosophy behind non-blocking is to not consume resources when waiting for something to happen. For example traditionally web servers dedicate one thread per request which is blocked until the request-response cycle is complete. On the other hand non-blocking, asynchronous IO makes servers to handle multiple request and responses with a single thread. This has a big impact on server performance. Now you handle more requests with a small number of fixed threads. Play uses JBoss Netty server\[5\][https://netty.io/|https://netty.io/] as HTTP server. Netty is one of the popular NIO server for the JVM and is included in the Play distribution by default. This design decision has a couple of consequences. First, the web programming model supported by Play is completely asynchronous. You are encouraged to handle requests in completely non-blocking fashion(we will also see that in the example we are building). Second, it is different from the Servlet 2.x model. In fact Play natively doesn't understand Servlets. This also has an impact on the way you deploy Play applications. Usually Netty does such a wonderful job of handling requests most of the Play applications uses Netty server in production(there are deployment options as well)
{info}
So when you point your browser to [http://localhost:9000/] the following happens:
* JBoss Netty server incepts the request and sends asynchronous message to Play framework.
* Play framework finds the action mapped to the URL by looking at the routes file (conf/routes). The routes file is the only configuration file that maps all the URLs supported by the application to the appropriate action. In this case the following route matches the url:
{code}
GET     /                           controllers.Application.index
{code}
Any HTTP GET type request that ends with '/' in the url will invoke the index action of the controller.Application object.
* The controller action is the one responsible to produce the response. The response could be in any format - text, json or html. The following index action is using the app/views/index.scala.html view to produce the response.

{code}
def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }
{code}
The Action is a simple simple abstraction over a function that takes a request and produces a response. Here *Ok* produces an HTTP 200 OK response with the contents of the index view.
{info:title=Everything in Play is a function}
This is one of those simple ideas that makes Play framework a joy to work with. Building an application using Play framework involves you writing multiple functions. A controller is nothing but a singleton object with collections of functions. Each action is a function that takes an HTTP request as a parameter and produces an HTTP response as the output.The view you render (e.g. index.scala.html) is also compiled to a function that takes one or more parameter and produces html or text or some type of response. So *views.html.index("Your new application is ready.")* is essentially invoking the *apply* method of *index* object by passing the "Your new application is ready." as a parameter. In Scala these are called function objects.
{info}
Enough theory. Lets write our first controller action. Copy paste the following action to your Application controller and refresh your browser(make sure your Play application is still running):
{code}
def find = Action {
    Ok(views.html.index("Coming soon))
  }
{code}
I made a deliberate mistake in the code so if everything goes ok you will see the following error page.
!https://raw.github.com/nraychaudhuri/find_events/master/images/error-page.png!
{center}Figure 4: error page
{center}
I am not sure about you but I don't know of any web framework that does such a good job of showing errors with line numbers(This only happens in Dev mode). Since almost everything is statically typed checked you see these helpful error messages if you make mistake in views or route files, yes route files are also type checked. For example if you point to a non-existence action in your route file you will get a compilation error.

First of all we need to create a new route for the the find action so that the client can invoke it using a URL.
{code:title=conf/routes|borderStyle=solid}
GET    /find/events/:name           controllers.Application.find(name: String)
{code}
The routes file not only maps URL to action, it can also parse part of the URL and pass that as a parameter to the action. Here the url part after /find/events/ is parsed into an identifier called name and passed as a parameter to the *find* action of the *Application* controller. The find action will take the name of the artist and return all the events associated with the artist using the REST API provided by Last.fm. But first you need to create an API account with Last.fm to access their API\[6\]. Once you acquire the API key you need to add that to application.conf file of your application. The application.conf file is the configuration file for Play applications. Starting from configuring log level to databases this file is used to configure Play applications.We will add our API key like following at the end of the application.conf file:
{code:title=conf/applicaton.conf|borderStyle=solid}
lastfm.api.key="<your api key goes here>"
{code}
The name of the key is important because we will use it in the code to access the API key. To fetch the events from Last.fm we will use the *artist.getEvents* api method by passing the API key and the artist name. For example the following URL will fetch all the events associated with artist name "Fun." in json format(make sure to put your API key):
{code}
curl -v "http://ws.audioscrobbler.com/2.0/?method=artist.getevents&artist=Fun.&api_key=<your api key>&format=json"
{code}
Now from the the find action, if we can construct the url using the artist name and the API key we can use the webservice client provided by Play to make the remote REST service call. Here is how that could be implemented in Play:
{code:title=Application.scala|borderStyle=solid}
package controllers

import play.api._
import play.api.mvc._
import play.api.libs.ws.WS
import java.net.URLEncoder
import play.api.Play._
import scala.concurrent._
import ExecutionContext.Implicits.global

object Application extends Controller {

  def index = Action { implicit request =>
    Ok(views.html.index("Your new application is ready."))
  }

  def find(artistName: String) = Action { request =>
    val rootUrl = "http://ws.audioscrobbler.com/2.0/"
    val apiMethod = "artist.getEvents"
    val apiKey = configuration.getString("lastfm.api.key").getOrElse("no key")              A
    val req = rootUrl +                                                                     B
          "?method=" + apiMethod +
          "&artist=" + URLEncoder.encode(artistName, "UTF-8") +
          "&api_key=" + apiKey +
          "&format=json"
    Async {                                                                                 C
      WS.url(req).get().map { response =>
        Ok(response.json)
      }
    }
  }
}
{code}
The find action retrieves the API Key (line A) from the application.con file using the *configuration* object provided by the *play.api.Play* object. The configuration object is created automatically when Play application starts and can be used to access all the configuration information provided in application.conf file. Then next the url is constructed(line B) using the given artist name and the API key. Finally in line C we are making the REST web service call using the *WS* client. In Play WS client provides a nice and easy abstraction to make web service calls. Here the *WS.url(req).get()* creates an instance of web service client for given url and *get()* makes an HTTP GET type request. The biggest benefit of WS client over any other HTTP client is that it is completely asynchronous. So the *get()* call in the case above will immediately return with a Promise of result. In the context of Play framework think of Promise as a read handle to some value that will be fulfilled some time in the future, like a proxy object of the actual result. The *map* method in the above code example is invoked on Promise and will be called when the Promise is completed, like a callback. Using the map method we are registering a callback with the promise which will be invoked when the promise is complete(that means when we get the response from the webservice). Inside the callback we are extracting the JSON response from the service and wrapping it as an HTTP 200 OK response.
{info:title=Everything is non-blocking}
Play framework is tuned to handle thousands of HTTP requests with limited number of threads. Without any tuning Play applications are known to handle thousands of request per seconds. And with additional tuning based on your application needs you can scale even further \[7\].So how is Play handling the incoming HTTP requests? The main engine behind is a concurrency framework called \[Akka\[8\]. Akka makes writing concurrency and distributed applications easy to write for developers. Akka provides higher level of concurrency abstractions over threads. Play uses the actor based concurrency model\[9\] to handle all the incoming requests. Netty asynchronously handles all the incoming packets and fires up an event to the Play request handler whenever a request is ready. The Play request handler uses pool of Akka actors to manage all the incoming requests by invoking appropriate controller actions. In Play framework actions should finish as soon as possible without blocking anything. Play developers uses abstractions like Promise to offload work asynchronously without waiting for it to finish (like in the example above).
{info}
But we still have a problem. We still don't have the actual response. We only have the promise for the response and we cannot return it back from the action because Play expects a response. The Async combinator in Play allows us to return the promise of a result back from an action. Internally Play will take necessary steps to extract the result when ready and send it to the Netty server so the response can be sent back to the client. So the find action is completely non-blocking and will not block any resources unnecessarily.

h2. Testing and Debugging Play

As we continue to build our application we need to verify our code is working. Traditionally this is done through writing automated unit tests. In the world of Play it's not any different. Play provides very useful helpers to write unit tests and functional tests. It comes with specs2\[10\] for unit testing and selenium \[11\]  for functional testing. Please take a look at the Play framework documentation for details. Additionally Play framework provides something called _Play console_ that allows you to interactively work with Play components. It is a REPL(Read-Evaluate-Print-Loop) for Play applications. Traditionally REPL is used to interactively work with programming language but here we will use it to interactively work with controller actions. To start the REPL fire up the following command in your project directory:
{code}
play test:console
{code}
This will start the Play console in test mode. The test mode will allow us to use the test helpers inside the REPL to make our life easier. Now without wasting time lets invoke our find action to check that it comes back to the json response from Last.fm. The following commands will import all the necessary classes and types we need to invoke the action.
{code}
scala> import play.api.test._
import play.api.test._

scala> import play.api.mvc._
import play.api.mvc._
{code}
The test package is imported so that we can create create fake HTTP request and application to invoke our action.
{code}
scala> play.api.Play.start(FakeApplication())
{code}
This will start an instance of the Play application. You don't have to start any server or process. Just invoking the *Play.start* by passing an instance of Application starts the fully functional Play application. In this case *FakeApplication* creates an instance of our application in test mode. The following code invokes the *find* action by passing "Fun." as an artist name with a FakeRequest.
{code}
scala> val AsyncResult(promise) = controllers.Application.find("Fun.").apply(FakeRequest("GET", "/"))
{code}
In Play action is simply a function that takes an HTTP request and returns a response. In this case we are passing an instance of FakeRequest (again because it's easy to create) to invoke the action. The content of the request here is not important because we are not using the request inside our action. Finally we get the promise we are looking for. Now we will await for the promise(await waits for the promise to complete) and then print the result.
{code}
scala> val result = Helpers.await(promise)
result: play.api.mvc.Result = SimpleResult(200, Map(Content-Type -> application/json; charset=utf-8))
scala> Helpers.contentAsString(result)
res2: String = {"events":{"event":[{"id":"3283420","title":"fun.","artists":{"artist":"fun.","headliner":"fun."},"venue":{"id":"8779401","name":"La Maroquinerie","location":{"geo:point":{"geo:lat":"48.868348","geo:long":"2.392217"},"city":"Paris","country":"France","street":"23 Rue Boyer","postalcode":"75020"},"url":"http://www.last.fm/venue/8779401+La+Maroquinerie","website":"http://www.lamaroquinerie.fr","phonenumber":"+33-(0)1-40333505","image":[{"#text":"http://userserve-ak.last.fm/serve/34/5492666.png","size":"small"},{"#text":"http://userserve-ak.last.fm/serve/64/5492666.png","size":"medium"},{"#text":"http://userserve-ak.last.fm/serve/126/5492666.png","size":"large"},{"#text":"http://userserve-ak.last.fm/serve/252/5492666.png","size":"extralarge"},{"#text":"http://userserve-ak.la...
{code}
We got the result we were looking for. I don't know about you but I think its pretty darn cool to invoke controllers interactively so that you can get a quicker feedback. This is not only restricted to controllers, you can literally invoke any part of the application from the console. The design decision to make everything a function in play has a benefit, we can invoke them from REPL without the help of any server process or tools. Please note that *await* is only applicable when you are testing code. In real world your code should be completely non-blocking.
{info:title=Play comes with build tool}
To build, compile and distribute your code Play bundles a build tool called simple build tool \[12\]. The simple build tool is the de-facto build tool used in Scala projects. This build tool provides features like incremental compilation, continuous testing, running tests, parallel task execution and very powerful plug-in support. Most of the magic of auto-reloading your changes, tasks like console and run are provided through the SBT (simple build tool) support. Every play project needs to define its own project and library dependencies using the SBT build file. This build file is automatically created with every Play project. Take a look at the project/Build.scala file of your project.
{info}
Now that we are convinced that our action is producing the JSON response lets move on to building the UI interface of our application.

h2. Adding UI using Scala, LESS and CoffeeScript

No web application is complete without a nice looking UI. Thanks to tools like Twitter bootstrap \[13\], LESS \[14\]and CoffeeScript \[15\] writing UI has never been so easy before. In fact amateurs like myself&nbsp; can also come up with a nice looking UI. Most of these new tools scraps the boilerplate out of the work. LESS extends CSS with dynamic behavior so that you can create variables and functions to reuse CSS code while CoffeeScript makes writing Javascript a nice experience. So where does all these fit in our Play discussion? Play natively supports all of these tools. You don't have to do anything extra to use these benefits.
{info:title=Type-safety for the win}
Anything that can be compiled is compiled by Play framework. This includes your Scala files, routes file and managed resources. Not only does it compile LESS and CoffeeScript files it also check them for error. Go ahead and try to introduce errors in one of these files and you will see the result. This means that you catch more errors during compilation and get a faster feedback. Internally Play uses \[Google closure compiler\[16\]\| to compile Javascript and catch errors.
{info}
Play provides two types of resources, managed and unmanaged. The managed dependencies like LESS and CoffeeScripts gets automatically compiled to css and javascript respectively whenever they are changed while unmanaged resources are all the files that you put under the public folder. These are mainly your static content. To save some time I have already created the less and coffee file for the find_events projects. So go ahead and download the find.less \[17\] and find.coffee \[18\] from the the github project and copy it into app/assets/stylesheets and app/assets/javascripts folders respectively. Any resources you add under assets are automatically managed by Play framework. Play framework will compile these files and produce find.css and find.js files which you can use in your html.

The html is generated by view templates in Play. The view template is a function that takes some parameter and produces HTML content. But it's not restricted to only HTML, you can produce other types of content as well. The templating language used in these templates are Scala. The good news is that it is quite easy to pick up the templating language even if you are Java developer. Usually the name of the view template is named after the action. Typically the view templates share a common view template that provides the layout of the application. In our case it is the main.scala.html. This file includes all the css, javascripts and creates the layout for the application. We will modify the file like following to add our find.css and find.js files like following:
{code:title=main.scala.html|borderStyle=solid}
@(title: String)(content: Html)                                                                                A

<!DOCTYPE html>

<html>
    <head>
        <title>@title</title>
        <link rel="stylesheet" media="screen" href="@routes.Assets.at("stylesheets/main.css")">
        <link rel="stylesheet" media="screen" href="@routes.Assets.at("stylesheets/find.css")">                B
        <link rel="shortcut icon" type="image/png" href="@routes.Assets.at("images/favicon.png")">
        <script src="@routes.Assets.at("javascripts/jquery-1.7.1.min.js")" type="text/javascript"></script>
        <script src="@routes.Assets.at("javascripts/find.js")" type="text/javascript"></script>            C
    </head>
    <body>
        @content
    </body>
</html>
{code}
The first line of the view template declares the parameters it accepts. The main.scala.html template takes two parameters, title of the page and the body of the page. Behind the scenes Play will compile this template into a function that also takes two parameters. The line B includes the generated find.css from find.less file using the *Assets.at* which provides additional support for Etag, caching and Javascript minification. You can you *Assets.at* to serve any public asset. Similarly line C includes the generated find.js file from find.coffee so that other view templates can use it.

Now lets modify the index.scala.html file to give it the same look as Figure 1. Since we are doing asynchronous programming at the server side why not take it all the way through by using ajax to asynchronously submit the request to the server.We will use built-in Jquery library to make an ajax request from the client. Here is how the index.scala.html page looks like after the change:
{code:title=index.scala.html|borderStyle=solid}
@(message: String)(implicit request: RequestHeader)

@helper.javascriptRouter("jsRoutes")(routes.javascript.Application.find)                                        A

@main("Find Events for an artist") {
  <div id="container">
   <h1>Find Events</h1>
   <form onsubmit="return false;">
     <input type="text" name="artist" placeholder="Enter artist name" id="artistName">
     <input type="button" class="button search" value="find" id="findButton"/>
   </form>
  </div>
  <div id="results">&nbsp;</div>

}
{code}
In the find.coffee file we register the click event handler for *findButton*. When the button is clicked an ajax request will be made to *Application.find* action. But wait a minute where is the url? In Play applications urls are specified only in one place, that is in the routes file. Instead whenever anyone needs a URL they use something called reverse routing. In line A we are using the Javascript reverse routing. The *helper.javascriptRouter* generates necessary Javascript functions that you can use to invoke the server side counterpart. Now if you refresh you should see a UI very similar to the one shown in figure 1. Find out whether your favorite band is playing near you :-)

h2. Summary

Play framework brings fun back into building web application for the the JVM, but we have just scratched the surface of the play framework in this article. One article is not enough to explain the breadth of functionality provided by Play. Lots of details are deliberately left out so that you can get a high level overview of Play framework. You should not stop here. Explore the framework and I guarantee you that you get your wow moments. I surely had fun building the sample application and I hope you had fun too.

h2. Resources

\[1\][http://www.playframework.org/]

\[2\][http://www.last.fm/api]

\[3\][https://github.com/nofluffjuststuff/nfjsmag-2013-03-nraychaudhuri/tree/master/find_events]

\[4\][http://www.playframework.org/documentation/2.0/Installing]

\[5\][https://netty.io/]

\[6\][http://www.last.fm/api/account/create]

\[7\][http://corp.klout.com/blog/2012/10/scaling-the-klout-api-with-scala-akka-and-play/]

\[8\][http://akka.io/]

\[9\][http://doc.akka.io/docs/akka/2.0.3/general/actors.html]

\[10\][http://etorreborre.github.com/specs2/]

\[11\][https://github.com/Fluentlenium/FluentLenium]

\[12\][https://github.com/harrah/xsbt/wiki]

\[13\][http://twitter.github.com/bootstrap/]

\[14\][http://lesscss.org/]

\[15\][http://coffeescript.org/]

\[16\][https://developers.google.com/closure/compiler/]

\[17\][https://raw.github.com/nraychaudhuri/find_events/master/app/assets/stylesheets/find.less]

\[18\][https://raw.github.com/nraychaudhuri/find_events/master/app/assets/javascripts/find.coffee]