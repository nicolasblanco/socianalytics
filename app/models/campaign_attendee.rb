class CampaignAttendee
  include Mongoid::Document
  include Mongoid::Timestamps

  field :cookie
  field :state

  referenced_in :campaign
end
