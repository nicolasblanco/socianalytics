class ShortUrl
  include Mongoid::Document
  include Mongoid::Timestamps
  
  @@valid_chars = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a
  cattr_reader :valid_chars
  
  field :chunk
  field :requests_counter_cache, :type => Integer
  
  referenced_in :user
  embeds_many :requests, :class_name => "ShortUrlRequest"
  embeds_many :redirections, :class_name => "ShortUrlRedirection"
  accepts_nested_attributes_for :redirections, :allow_destroy => true, :reject_if => proc { |attributes| attributes['full_url'].blank? }
  
  after_initialize :set_defaults
  validates_uniqueness_of :chunk
  validates_presence_of :chunk
  validates_format_of :chunk, :with => /\A[A-Za-z0-9\-_]{1,99}\z/
  validates_presence_of :redirections
  validates_associated :redirections
  
  def self.random_chunk
    "".tap do |chunk|
      (rand(4) + 1).times { chunk << valid_chars[rand(valid_chars.size)] }
    end
  end
  
  def self.unused_random_chunk
    while 1 do
      break unless ShortUrl.exists?(:conditions => { :chunk => (chunk = random_chunk) })
    end
    chunk
  end
  
  def add_request(request)
    requests.create(:referrer => request.referrer, :user_agent => request.user_agent)
    inc(:requests_counter_cache, 1)
  end
  
  def url
    "http://#{ShortUrlConfig.host}/#{chunk}"
  end
  
  protected
  def set_defaults
    self.chunk ||= self.class.unused_random_chunk
  end
end

