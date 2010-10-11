class BitlyConfig
  cattr_accessor :username, :api_key
end

Bitly.use_api_version_3
BitlyConfig.username = "qualified"
BitlyConfig.api_key = "R_a1424ecf8d467a1d0a2010f218f2a021"
