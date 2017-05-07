class ErrorsController < ApplicationController

  def not_found
    unless params[:a].nil?
      logger.info "404 Error with: '#{params[:a]}'"
    end
  end

  def internal_error
    unless params[:a].nil?
      logger.info "Error with: '#{params[:a]}'"
    end
  end

  def routing
    unless params[:a].nil?
      logger.info "500 Error with: '#{params[:a]}'"
    end
    render :action => "internal_error"
  end

end
