# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.statuses = {}

@beginSearch = (id, hashtag) ->
  $.ajax(
    type: 'GET'
    url: '/events/statuses'
    data: { id: id, hashtag: hashtag }
  ).success (resp) ->
    window.statuses = resp.data
    statusesHolder = $('#statuses-holder')
    galleryList = $('.galleryList')
    statusesHolder.html(null)
    galleryList.html(null)

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
            <a class='btn btn-default view-status' href='#' onClick='openModal(\"" + id + "\", \"" + hashtag + "\")'>
              <i class='fa fa-eye fa-lg'></i>
            </a>
          </td>
        </tr>
      ")
      galleryList.append("
        <li>
          <div>
            <a>
              <img class='pix' src=" + images[0] + ">
              <div class='pixDesc'>
                " + text + "
              </div>
            </a>

          </div>
        </li>
      ")


  if window.fetchStatusesTimeOut != undefined
    clearTimeout(window.fetchStatusesTimeOut)

  window.fetchStatusesTimeOut = setTimeout(beginSearch, 60000, id, hashtag)

@openModal = (id, hashtag) ->
  element = $('#status-modal')
  header = $('#status-header')
  holder = $('#status-modal-holder')
  data = statuses[id]
  images = data.images
  totalImage = images.length


  header.html("<h2 class='modal-title'>#" + hashtag + "</h2>")

  html = "<div class='container-fluid'>
            <img src=" + images[0] + " width='100%' />
          </div>"

  html += "<div class='centered'><h4>" + data.text + "</h4></div>"

  holder.html(html)

  element.modal('show')

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

  $('#galleryModal').on 'shown.bs.modal', ->

    settings = 
      height: $(window).height()
      width: $(window).width()
      radius: 200
      speed: 0.5
      slower: 0.2
      timer: 20
      fontMultiplier: 15
      hoverStyle:
        border: 'none'
        color: '#0b2e6f'
      mouseOutStyle:
        border: ''
        color: ''
    $('.gallery').tagoSphere settings

      






  


      
    
