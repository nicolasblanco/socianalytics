class Post
  include Mongoid::Document
  
  field :title
  field :author
  field :published_at
  field :content
end
