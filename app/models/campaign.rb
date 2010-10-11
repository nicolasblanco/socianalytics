class Campaign
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :bitly_url

  referenced_in :user
  references_many :campaign_attendees

  validates_presence_of :name
end
