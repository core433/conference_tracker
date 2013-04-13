class StaticPagesController < ApplicationController
  def home
  	@events = Event.all()
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
