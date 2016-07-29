# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  renderEvents = (events) ->
    eventsHolder = $('#events-holder')

    eventsHolder.html(null)

    $.each events, (id, v) ->
      eventsHolder.prepend("
        <tr>
          <td>
            <h4><a class='event-link' href='/events/" + id + "'>#" + v.title + "</a></h4>
          </td>
        </tr>
      ")

  fetchEvents = ->
    $.ajax(
      type: 'GET'
      url: '/events/fetch'
    ).success (resp) ->
      console.log resp
      renderEvents(resp.data)

  startFetch = () ->
    fetchEvents()

    setTimeout(startFetch, 60000)

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
    startFetch()
