class Tag
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :blog_tags
  has n, :blogs, :through => :blog_tags
end