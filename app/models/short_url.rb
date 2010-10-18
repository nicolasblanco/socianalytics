class ShortUrl
  include Mongoid::Document
  include Mongoid::Timestamps
  
  @@valid_chars = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a
  cattr_reader :valid_chars
  
  field :chunk
  
  referenced_in :user
  embeds_many :requests, :class_name => "ShortUrlRequest"
  embeds_many :redirections, :class_name => "ShortUrlRedirection"
  
  before_validation :generate_chunk
  validates_uniqueness_of :chunk
  
  def self.random_chunk
    "".tap do |chunk|
      (rand(4) + 1).times { chunk << valid_chars[rand(valid_chars.size)] }
    end
  end
  
  def add_request(request)
    requests.create(:referrer => request.referrer, :user_agent => request.user_agent)
  end
  
  protected
  def generate_chunk
    self.chunk ||= self.class.random_chunk
    while ShortUrl.exists?(:conditions => { :chunk => self.chunk }) do
      self.chunk = self.class.random_chunk
    end
  end
end

