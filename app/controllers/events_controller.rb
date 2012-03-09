class EventsController < ApplicationController
  respond_to :html

  def index
    @events = Event.scoped
    respond_with @events
  end

  def show
    @event = Event.find_by_slug!(params[:id])
    respond_with @event
  end
end
