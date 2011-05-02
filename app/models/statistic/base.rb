class Statistic::Base
	include Mongoid::Document
  include Mongoid::Timestamps

  field :content, default: []

  def add_content(content)
    self.content << { :at => Time.now, :value => content }
  end
end
