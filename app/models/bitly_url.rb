class BitlyUrl
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :url_chunk
  field :number_of_clicks, :type => Integer
  
  embedded_in :tweet, :inverse_of => :bitly_url
end
