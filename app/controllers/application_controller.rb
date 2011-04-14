# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from Mongoid::Errors::DocumentNotFound, :with => :not_found
  
  protected
  def not_found
    render :template => "layouts/404", :layout => false, :status => :not_found
  end
end
