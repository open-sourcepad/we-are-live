class EventsController < ApplicationController
  def index
  end

  def show
    path = "events/#{ params[:id] }"
    event = firebase.get(path)
    @id = params[:id]
    @header = "#{ event.body['title'] }"
  end

  def create
    events = firebase.get('events')

    if events.body.blank?
      titles = []
    else
      titles = events.body.values.collect{|v| v['title']}
    end

    if titles.include?(params[:hashtag])
      render json: { success: false, error: { message: 'Event already exsists' } }, status: 403
    else
      firebase.push("events", { title: params[:hashtag], data: 'blank' })

      data = firebase.get('events').body

      render json: { success: true, data: data }, status: 200
    end
  end

  def fetch
    events = firebase.get('events')
    data = events.body || []

    render json: { success: true, data: data }, status: 200
  end

  def statuses
    event_path = "events/#{ params[:id] }"
    resp = twitter_service.search(params[:hashtag])
    data = []

    resp.each do |status|
      data << {
        id: status['id'],
        text: status['text'].gsub("\n", ' '),
        images: resp.first['entities']['media'].collect{ |m| m['media_url']  }
      }
    end

    firebase.update(event_path, { data: data })

    render json: { success: true, data: data }, status: 200
  end

  private
  def twitter_service
    @twitter_service ||= TwitterService.new
  end
end
