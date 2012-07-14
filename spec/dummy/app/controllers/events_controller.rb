class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.save!
    redirect_to @event
  end

  def edit
    @event = Event.new(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes!(params[:event])
    redirect_to @event
  end

  def show
    @event = Event.find(params[:id])
  end
end
