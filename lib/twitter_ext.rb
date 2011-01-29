class TwitterExt
  def self.all_pages(twitter_client, method, options = {})
    [].tap do |tp|
      cursor = -1
      while cursor != 0 do
        resp = twitter_client.send(method, options.merge({ :cursor => cursor }))
        tp << resp
        cursor = resp.next_cursor
      end
    end
  end
end
