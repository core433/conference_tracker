class EventsController < ApplicationController
  def new
  end

  def show
  	@event = Event.find(params[:id])
  end

end
