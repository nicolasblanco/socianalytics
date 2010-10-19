class ShortUrlConstraint
  def matches?(request)
    true if request.host == ShortUrlConfig.host && request.path =~ /\A\/[A-Za-z0-9\-_]{0,99}[A-Za-z0-9\-_\/]\z/
  end
end

