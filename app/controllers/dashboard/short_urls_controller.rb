class Dashboard::ShortUrlsController < Dashboard::DashboardController
  before_filter :load_model, :only => %w(show destroy)
  
  protected
  def load_model
    @short_url = ShortUrl.find(params[:id])
  end
  
  public
  def index
    @short_url = ShortUrl.new
    5.times { @short_url.redirections.build }
    @short_urls = ShortUrl.desc(:created_at).paginate(:page => params[:page], :per_page => 10)
  end
  
  def create
    @short_url = ShortUrl.new(params[:short_url])
    if @short_url.save
      redirect_to dashboard_short_urls_path, :notice => "URL shortened successfully!"
    else
      render 'index'
    end
  end
  
  def destroy
    @short_url.destroy
    
    redirect_to dashboard_short_urls_path, :notice => "URL destroyed successfully!"
  end
end
