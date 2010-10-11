Twitter.configure do |config|
  config.consumer_key = "jW4XqO7X4SpcsLBDq0v8Q"
  config.consumer_secret = "7kk22UHviG3wrkc9hKVdcxxQ1eYBdX4E39oV9ogw"
end

Devise::Twitter.setup do |config|
  config.consumer_key = Twitter.consumer_key
  config.consumer_secret = Twitter.consumer_secret
  config.scope = :user
end
