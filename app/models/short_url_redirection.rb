class ShortUrlRedirection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :full_url
  field :description
  
  embedded_in :short_url, :inverse_of => :redirections
  
  validates_format_of :full_url, :with => /^(#{URI::regexp(%w(http https))})$/ 
end
