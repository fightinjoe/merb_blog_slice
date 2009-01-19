if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices', :immediate => true
  dependency 'merb-helpers'
  Merb::Plugins.add_rakefiles "merb_blog_slice/merbtasks", "merb_blog_slice/slicetasks", "merb_blog_slice/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb_blog_slice
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_blog_slice][:layout] ||= :merb_blog_slice
  
  # All Slice code is expected to be namespaced inside a module
  module MerbBlogSlice
    
    # Slice metadata
    self.description = "MerbBlogSlice is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "Engine Yard"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbBlogSlice)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_blog_slice_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      #scope.match("/login").to(:controller => "Sessions", :action => "create").name(:login)
      #scope.match("/logout").to(:controller => "Sessions", :action => "destroy").name(:logout)
      #scope.resources :users

      scope.namespace :admin do |admin|
        admin.resources :blogs
      end

      # RESTful routes
      #scope.resources :blogs do |b|
      #  b.resources :comments
      #end

      #scope.resources :comments

      scope.match(%r{/(\d+)/(\d+)/([a-zA-Z\-]+)}).to(
        :controller => 'blogs', :action => 'show', :year => "[1]", :month => "[2]", :path_title => "[3]"
      )

      # NAMED routes
      scope.match('/contact').to( :controller => 'comments', :action => 'new' ).name( :contact )

      # scope.match('/:category_title').to( :controller => 'blogs', :action => 'index' ).name( :category )
      # resources :posts

      # Used for path generation
      scope.match('/:year/:month/:path_title').to( :controller => 'blogs', :action => 'show' ).name( :blog_by_date )

      scope.match('/:path_title').to( :controller => 'blogs', :action => 'page' ).name( :page )

      # This is the default route for /:controller/:action/:id
      # This is fine for most cases.  If you're heavily using resource-based
      # routes, you may want to comment/remove this line to prevent
      # clients from calling your create or destroy actions with a GET
      scope.default_routes

      # Change this for your home page to be available at /
      scope.match('/').to(:controller => 'blogs', :action =>'index' )



      ## example of a named route
      #scope.match('/index(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      ## the slice is mounted at /merb_blog_slice - note that it comes before default_routes
      #scope.match('/').to(:controller => 'main', :action => 'index').name(:home)
      ## enable slice-level default routes by default
      #scope.default_routes
    end
    
  end
  
  # Setup the slice layout for MerbBlogSlice
  #
  # Use MerbBlogSlice.push_path and MerbBlogSlice.push_app_path
  # to set paths to merb_blog_slice-level and app-level paths. Example:
  #
  # MerbBlogSlice.push_path(:application, MerbBlogSlice.root)
  # MerbBlogSlice.push_app_path(:application, Merb.root / 'slices' / 'merb_blog_slice')
  # ...
  #
  # Any component path that hasn't been set will default to MerbBlogSlice.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbBlogSlice.setup_default_structure!
  
  # Add dependencies for other MerbBlogSlice classes below. Example:
  # dependency "merb_blog_slice/other"
  
end