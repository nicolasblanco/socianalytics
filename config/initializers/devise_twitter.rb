Twitter.configure do |config|
  config.consumer_key = "DZF1YQr3OKKNb8sCrRwQ"
  config.consumer_secret = "3ci4zDPNvYYV84nxOCIWqI693ouDFGU6CKZHTiw5L0"
end

Devise::Twitter.setup do |config|
  config.consumer_key = Twitter.consumer_key
  config.consumer_secret = Twitter.consumer_secret
  config.scope = :user
end
