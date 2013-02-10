errorResponse = ->
  $("#results").append "<h2>No Events found</h2>"
successResponse = (json) ->
  $.each json.events.event, (i, e) ->
    div = "<div>"
    div += "<h2>Title:" + e.title + "</h2>"
    div += "<h3>City:" + e.venue.location.city + "</h3>"
    div += "<h3>startDate:" + e.startDate + "</h3>"
    div += "<h3>Description:</h3>"
    div += "<div>" + e.description + "</div>"
    div += "</div>"
    $("#results").append div

renderResponse = (json) ->
  if json.events is `undefined` or json.events.event is `undefined`
    errorResponse()
  else
    successResponse json
showResults = (json) ->
  result = $.parseJSON(json)
  $("#results").html ""
  renderResponse json
$(document).ready ->
  $("#findButton").click (e) ->
    name = $("#artistName").val()
    jsRoutes.controllers.Application.find(name).ajax success: (data) ->
      showResults data

    false

