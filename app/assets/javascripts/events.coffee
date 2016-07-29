# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@beginSearch = (id, hashtag) ->
  $.ajax(
    type: 'GET'
    url: '/events/statuses'
    data: { id: id, hashtag: hashtag }
  ).success (resp) ->
    statusesHolder = $('#statuses-holder')
    statusesHolder.html(null)

    $.each resp.data, (id, data) ->
      images = data.images
      text = data.text

      statusesHolder.append("
        <tr>
          <td class='col-xs-2'>
            <img src='" + images[0] + "' width='150' height='150' >
          </td>
          <td class='col-xs-9 status-text'>
            <h4>
              " + text + "
            </h4>
          </td>
          <td class='col-xs-1 actions'>
            <a class='btn btn-default'>
              <i class='fa fa-print fa-lg'></i>
            </a>
          </td>
        </tr>
      ")

  if window.fetchStatusesTimeOut != undefined
    clearTimeout(window.fetchStatusesTimeOut)

  window.fetchStatusesTimeOut = setTimeout(beginSearch, 60000, id, hashtag)

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
      renderEvents(resp.data)

      if window.fetchEventsTimeOut != undefined
        clearTimeout(window.fetchEventsTimeOut)

      window.fetchEventsTimeOut = setTimeout(fetchEvents, 60000)


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

  if $('#events-holder').size() > 0
    fetchEvents()
