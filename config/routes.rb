Socianalytics::Application.routes.draw do
      
  namespace :admin do
    resources :users do
      post 'update_admin_status', :on => :member
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"
  
  namespace :dashboard do
    resources :short_urls
    resources :stats do
      collection do
        post :update_twitter_user
        get :popular_followers
        get :spam_followers
      end
    end
    resource :profile do
      member do
        post :twitter_link
        delete :destroy_twitter_link
        get :twitter_callback
        
        post :facebook_link
        get :facebook_callback
      end
    end
    root :to => "home#show"
  end
  
  match "settings" => "settings#show"
  
  resource :setting, :as => "settings" do
    member do
      get :facebook_session
    end
  end
  
  resources :campaigns do
    get :tracker, :on => :member
  end
  
  devise_for :user, :controllers => { :sessions => "sessions" }
  
  resources :short_urls, :only => %w(create)
  
  #match '/dashboard' => "dashboards#show", :as => :user_root
  
  match '/:chunk' => "short_urls#show", :constraints => ShortUrlConstraint.new
  match '/' => "short_urls#index", :constraints => { :host => "ixi.me" }
  
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id(.:format)))'
  root :to => "home#index"
end

