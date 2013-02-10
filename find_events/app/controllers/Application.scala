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
    val apiKey = configuration.getString("lastfm.api.key").getOrElse("no key")
    val req = rootUrl + 
    			"?method=" + apiMethod + 
    			"&artist=" + URLEncoder.encode(artistName, "UTF-8") + 
    			"&api_key=" + apiKey +
    			"&format=json"
    Async {
      WS.url(req).get().map { response =>
        Ok(response.json)
      }
    }
  }
}