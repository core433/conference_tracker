class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # Froce signout to prevent CSRF attacks
  def handle_unferified_request
  	sign_out
  	super
  end
end
