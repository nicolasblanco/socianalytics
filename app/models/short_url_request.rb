class ShortUrlRequest
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :short_url, :inverse_of => :requests
end

