# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
 


 showStats = () ->
  $.ajax 
   url: "/poker_stat/index"
   type: "GET"
   timeout: 10000
   dataType: "script"
   data: {}
   success: ->
   error: ->
     console.log("it doesn't work!")
 
 showStats()

