class TwitterStatus < BasicActiveModel
  attr_accessor :message

  def update_for_user(user)
    user.twitter_client.update(message)
  rescue
    false
  end
end
