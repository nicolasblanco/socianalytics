class ShortUrlRequest
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :referrer
  field :user_agent
  
  embedded_in :short_url, :inverse_of => :requests
end

