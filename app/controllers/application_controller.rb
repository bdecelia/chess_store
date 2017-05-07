class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Error Handling
  # --------------
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to take this action."
    last_page = session[:last_page].nil? ? home_path : session[:last_page]
    redirect_to last_page #TODO: link to back
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = "Record not found."
    last_page = session[:last_page].nil? ? home_path : session[:last_page]
    redirect_to last_page #TODO: link to back
  end

  rescue_from ActionController::UnknownController do |exception|
    flash[:error] = "Page not found."
    last_page = session[:last_page].nil? ? home_path : session[:last_page]
    redirect_to last_page #TODO: link to back
  end

  rescue_from ActionController::RoutingError do |exception|
    flash[:error] = "Page not found."
    last_page = session[:last_page].nil? ? home_path : session[:last_page]
    redirect_to last_page #TODO: link to back
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end
end
