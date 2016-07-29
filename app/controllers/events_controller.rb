class EventsController < ApplicationController
  def index
  end

  def show
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

      data = firebase.get('events').body.values.collect{ |v| v['title'] }

      render json: { success: true, data: data }, status: 200
    end
  end

  def fetch
    events = firebase.get('events')

    if events.body.blank?
      data = []
    else
      data = events.body.values.collect{|v| v['title']}
    end

    render json: { success: true, data: data }, status: 200
  end
end
