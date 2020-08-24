# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

discard = []

$(document).on 'turbolinks:load', ->
 


 editDiscard = (discardUrl) ->
  $.ajax 
   url: discardUrl
   type: "GET"
   timeout: 10000
   dataType: "script"
   data: {discard: discard}
   success: ->
   error: ->
     console.log("discard ajax doesn't work!")

 @discard = (game) ->
  if game == ""
    newGame()
  else
   discardUrl = "/games/edit?game=" + game.toString()
   discardArray()
   editDiscard(discardUrl)

 @newGame = () ->
  $.ajax 
   url: "/games/new"
   type: "GET"
   timeout: 10000
   dataType: "script"
   data: {}
   success: ->
     discard = []
   error: ->
     console.log("new game ajax does not work!")

 @suggestDiscard = () ->
  game = $('.game').val()
  $.ajax 
   url: "/games/show"
   type: "GET"
   timeout: 10000
   dataType: "script"
   data: {game: game}
   success: ->
    error: ->
     console.log("discard suggestion does not work!")

 newGame = () ->
  $.ajax 
   url: "/games/new"
   type: "GET"
   timeout: 10000
   dataType: "script"
   data: {}
   success: ->
     discard = []
   error: ->
     console.log("internal new game ajax does not work!")

 @colorToggle = (card) ->
  if card.style.backgroundColor == "rgb(255, 200, 0)"
   card.style.backgroundColor = ""
  else
   card.style.backgroundColor = "rgb(255, 200, 0)"


 discardArray = () ->
  if $("#p0").css("backgroundColor")=="rgb(255, 200, 0)"
   discard.push("0")
  if $("#p1").css("backgroundColor")=="rgb(255, 200, 0)"
   discard.push("1")
  if $("#p2").css("backgroundColor")=="rgb(255, 200, 0)"
   discard.push("2")
  if $("#p3").css("backgroundColor")=="rgb(255, 200, 0)"
   discard.push("3")  
  if $("#p4").css("backgroundColor")=="rgb(255, 200, 0)"
   discard.push("4")





