if ActionController::Routing.name =~ /ActionDispatch/
  # Rails 3
  
  ActionDispatch::Routing::Mapper.class_eval do
    protected
  
    def devise_dacs_authenticatable(mapping, controllers)
      sign_out_via = (Devise.respond_to?(:sign_out_via) && Devise.sign_out_via) || [:get, :post]

      # service endpoint for DACS server
      get "service", :to => "#{controllers[:dacs_sessions]}#service", :as => "service"
      post "service", :to => "#{controllers[:dacs_sessions]}#single_sign_out", :as => "single_sign_out"

      resource :session, :only => [], :controller => controllers[:dacs_sessions], :path => "" do
        get :new, :path => mapping.path_names[:sign_in], :as => "new"
        get :unregistered
        post :create, :path => mapping.path_names[:sign_in]
        match :destroy, :path => mapping.path_names[:sign_out], :as => "destroy", :via => sign_out_via
      end      
    end
  end
else
  # Rails 2
  
  ActionController::Routing::RouteSet::Mapper.class_eval do
    protected
    
    def dacs_authenticatable(routes, mapping)
      routes.with_options(:controller => 'devise/dacs_sessions', :name_prefix => nil) do |session|
        session.send(:"#{mapping.name}_service", '/service', :action => 'service', :conditions => {:method => :get})
        session.send(:"#{mapping.name}_service", '/service', :action => 'single_sign_out', :conditions => {:method => :post})
        session.send(:"unregistered_#{mapping.name}_session", '/unregistered', :action => "unregistered", :conditions => {:method => :get})
        session.send(:"new_#{mapping.name}_session", mapping.path_names[:sign_in], :action => 'new', :conditions => {:method => :get})
        session.send(:"#{mapping.name}_session", mapping.path_names[:sign_in], :action => 'create', :conditions => {:method => :post})
        session.send(:"destroy_#{mapping.name}_session", mapping.path_names[:sign_out], :action => 'destroy', :conditions => { :method => :get })
      end
    end
  end
end
