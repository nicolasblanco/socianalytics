class ShortUrlsController < ApplicationController
  layout 'url_shortener'
  before_filter :authenticate_user!, :only => %w(create)
  
  def show
    @short_url = ShortUrl.first(:conditions => { :chunk => params[:chunk] })
    if @short_url
      @short_url.add_request(request)
      redirect_to @short_url.redirections.first.full_url unless @short_url.redirections.many?
    else
      raise Mongoid::Errors::DocumentNotFound.new(ShortUrl, params[:chunk])
    end
  end
  
  def create
    @short_url = current_user.short_urls.create(:redirections => [{ :full_url => params[:url] }])
    respond_to do |format|
      format.xml
    end
  end
end

