module ApplicationHelper
  def format_stats_for_js(user = current_user)
    res = ""
    res << "[{name: 'twitter : #{user.twitter_handle}', data: [#{user.user_stats.map(&:number_of_followers).join(",")}]}"
    if user.facebook_access_token.present? && user.facebook_page_id.present?
      res << ", {name: 'facebook : #{user.facebook_page_id}', data: [#{user.user_stats.map { |us| us.number_of_facebook_fans || 0 }.join(",")}]}"
    end
    res << "]"
    res.html_safe
  end
end
