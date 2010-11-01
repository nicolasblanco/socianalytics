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
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
  
  def error_messages_for(object)
    if object.errors.any?
      content_tag(:div, "One or more errors prevented the form from being submitted. Please see the errors below and correct any problems.", :class => "error-overview")
    end
  end
  
  def page_title(title)
    content_for(:page_title) { title }
  end
  
  def clippy(text, bgcolor='#FFFFFF')
    str = <<-EOF
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              id="clippy" >
      <param name="movie" value="/flash/clippy.swf"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="text=#{text}">
      <param name="bgcolor" value="#{bgcolor}">
      <embed src="/flash/clippy.swf"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="text=#{text}"
             bgcolor="#{bgcolor}"
      />
      </object>
    EOF
    str.html_safe
  end
end
