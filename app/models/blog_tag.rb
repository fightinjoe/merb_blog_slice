class BlogTag
  include DataMapper::Resource

  property :id,      Serial
  property :tag_id,  Integer
  property :blog_id, Integer

  belongs_to :tag
  belongs_to :blog
end