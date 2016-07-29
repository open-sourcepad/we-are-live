# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  renderEvents = (events) ->
    eventsHolder = $('#events-holder')

    eventsHolder.html(null)

    $.each events, (_, v) ->
      eventsHolder.prepend("<div class='well'>" + v + "</div>")

  fetchEvents = ->
    $.ajax(
      type: 'GET'
      url: '/events/fetch'
    ).success (resp) ->
      console.log resp
      renderEvents(resp.data)

  $('#add-event-button').click (e) ->
    e.preventDefault()

    input = $('#new-event-input')
    event = input.val()

    ajaxCall = $.ajax(
      type: 'POST'
      url: '/events'
      data: { hashtag: event }
    ).success (resp) ->
      renderEvents resp.data
     .error (resp) ->
       console.log resp

    input.val(null)

  if $('#events-holder')
    fetchEvents()

  $('#galleryModal').on 'shown.bs.modal', ->
      $('.gallery').tagcloud({centrex:250, centrey:250, init_motion_x:10, init_motion_y:10, fps: 120, max_zoom: 500, zoom: 130, random_points: 100})
    


  


      
    
