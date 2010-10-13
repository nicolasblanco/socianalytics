class CampaignsController < LoggedController

  before_filter :load_campaign, :only => %w(edit update destroy show tracker)

  protected

  def load_campaign
    @campaign = current_user.campaigns.find(params[:id])
  end

  public

  def index
    @campaigns = current_user.campaigns.desc(:created_at)
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = current_user.campaigns.build params[:campaign]
    if @campaign.save
      redirect_to campaigns_path
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @campaign.update_attributes params[:campaign]
      redirect_to campaigns_path
    else
      render :action => "update"
    end
  end

  def show
    @campaign_attendees = @campaign.campaign_attendees.desc(:created_at)
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path
  end

  def tracker
    if params["qfState"] == "start" && params["qfRef"] == @campaign.bitly_url
      ca = @campaign.campaign_attendees.build :state => params[:state]
      ca.save
      cookies[:qfCampaignAttendee] = ca.id
    elsif params[:state] == "finish"
      ca = CampaignAttendee.find cookies[:qfCampaignAttendee]
      ca.state = "finish"
      ca.save
    end

    respond_to do |format|
      format.js{ render :nothing => true }
    end
  end
end
