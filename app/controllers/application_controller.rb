class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from Mongoid::Errors::DocumentNotFound, :with => :not_found
  
  protected
  def not_found
    render :template => Rails.root.join("public", "404.html"), :layout => false, :status => :not_found
  end
end
