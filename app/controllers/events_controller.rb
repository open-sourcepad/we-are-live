class EventsController < ApplicationController
  def index
  end

  def show
  end

  def create
    events = firebase.get('events')
    titles = events.body.values.collect{|v| v['title']}

    if titles.include?(params[:hashtag])
      render json: { success: false, error: { message: 'Event already exsists' } }, status: 403
    else
      firebase.push("events", { title: params[:hashtag], data: 'blank' })

      data = firebase.get('events').body.values.collect{ |v| v['title'] }

      render json: { success: true, data: data }, status: 200
    end
  end

  def fetch
    data = firebase.get('events').body.values.collect{ |v| v['title'] }

    render json: { success: true, data: data }, status: 200
  end
end
