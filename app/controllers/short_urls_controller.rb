class ShortUrlsController < ApplicationController
  layout 'url_shortener'
  
  def show
    @short_url = ShortUrl.first(:conditions => { :chunk => params[:chunk] })
    if @short_url
      @short_url.add_request(request)
      redirect_to @short_url.redirections.first.full_url unless @short_url.redirections.many?
    else
      raise Mongoid::Errors::DocumentNotFound.new(ShortUrl, params[:chunk])
    end
  end
end
