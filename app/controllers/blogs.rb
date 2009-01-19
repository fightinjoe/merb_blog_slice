class MerbBlogSlice::Blogs < MerbBlogSlice::Application

  def index
    provides :rss
    params[:format] == 'rss' ? index_rss : index_html

    render
  end

  def show
    find_blog
    #@category = @blog.category
    #@comment  = Comment.new( :blog_id => @blog.id )
    render
  end

  def page
    @blog = Blog.first( :path_title => params[:path_title], :page.not => nil )
    raise NotFound unless @blog
    render :show
  end

  private

    def index_rss
      @blogs = Blog.get_rss
    end

    def index_html
      title     = params[:category_title]
      #@category = title && Category.first( :title => title )

      raise NotFound if title && @category.nil?

      options = { :page => nil } #{ :category_id => (@category ? @category.id : nil), :category_id.not => @about.id }
      @blogs  = Blog.paginate( options ).page( params[:page] )
    end

    def find_blog
      id, path_title, month, year = params[:id], params[:path_title], params[:month], params[:year]
      if id == 'latest'
        #@about = Category.first(:title => 'About')
        @blog  = Blog.last #( :category_id.not => (@about ? @about.id : -1) )
      else
        @blog = id ? Blog.get( id ) : Blog.first( :path_title => path_title, :year => year, :month => month )
      end
      raise NotFound unless @blog
    end
  
end