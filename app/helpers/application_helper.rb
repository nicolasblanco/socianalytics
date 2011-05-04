# encoding: utf-8
module ApplicationHelper
  
  def js_array(array, options = {})
    options[:strings].present? ? "['#{array.join('\',\'')}']" : "[#{array.join(', ')}]"
  end

  def pagination_buttons(collection)
    link_to("Précédent", collection.previous_page ? params.merge(:page => collection.previous_page) : "#", "data-role" => "button", "data-icon" => "arrow-l") +
    link_to("Suivant", collection.next_page ? params.merge(:page => collection.next_page) : "#",   "data-role" => "button", "data-icon" => "arrow-r")
  end
  
  # Pluralize helper for French language.
  #
  # Because French pluralization has special rules :
  # Example :
  # pluralize(0, "degré") # => "0 degré"
  # pluralize(1, "degré") # => "1 degré"
  # pluralize(2, "degré") # => "2 degrés"
  # pluralize(0.5, "degré") # => "0.5 degré"
  # pluralize(1.9, "degré") # => "1.9 degré"
  # pluralize(-1.9, "degré") # => "-1.9 degré"
  # pluralize(-2, "degré") # => "-2 degrés"
  #
  # Options :
  # :without_count : if you don't want to output the count (only the word),
  # :plural : to use a custom plural.
  #
  def pluralize(count, singular, options = {})
    "".tap do |result|
      result << "#{count || 0} " unless options[:without_count]
      result << (count.to_i > -2 && count.to_i < 2 ? singular : (options[:plural] || singular.pluralize)).to_s
    end
  end
  
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
