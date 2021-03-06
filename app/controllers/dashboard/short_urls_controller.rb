# encoding: utf-8
class Dashboard::ShortUrlsController < Dashboard::DashboardController
  before_filter :load_model, :only => %w(show destroy live)
  
  protected
  def load_model
    @short_url = current_user.short_urls.find(params[:id])
  end

  def load_models
    @twitter_status = TwitterStatus.new(:message => "#{current_user.short_urls.any? ? current_user.short_urls.last.url : ''} >")
    @short_url.redirections.build if @short_url.redirections.empty?
    @short_urls = current_user.short_urls.desc(:created_at).paginate(:page => params[:page], :per_page => 10)
  end
  
  public
  def index
    @short_url = ShortUrl.new
    load_models
    respond_to do |format|
      format.html
      format.json { render :json => @short_urls.map { |short_url| { :id => short_url.id, :clicks_count => short_url.requests_counter_cache } } }
    end
  end

  def show
    @twitter_status = TwitterStatus.new(:message => "#{@short_url.url} >")
  end

  def update_twitter_status
    @twitter_status = TwitterStatus.new(params[:twitter_status])
    if @twitter_status.valid? && @twitter_status.update_for_user(current_user)
      redirect_to dashboard_short_urls_path, :notice => "Status Twitter mis à jour avec succès !"
    else
      load_models
      render 'index'
    end
  end

  def live
    respond_to do |format|
      format.html
      format.json { render :json => { :count => @short_url.requests.count } }
    end
  end
  
  def create
    @short_url = current_user.short_urls.build(params[:short_url])
    if @short_url.save
      redirect_to dashboard_short_urls_path, :notice => "URL shortened successfully!"
    else
      load_models
      render 'index'
    end
  end
  
  def destroy
    @short_url.destroy
    
    redirect_to dashboard_short_urls_path, :notice => "URL destroyed successfully!"
  end
end

