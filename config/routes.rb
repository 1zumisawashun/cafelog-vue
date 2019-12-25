Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post '/rate' => 'rater#create', :as => 'rate'

  root 'shops#index'

  resources :shops do
    collection do
      get :search
    end
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:show,:create,:destroy]
    resources :images, only: [:show,:create,:destroy]
  end

  devise_for :users, controller: {
    registration: "users/registrations",
    session: "users/sessions"
  }
  resources :users, only: [:show] #do
    #resources :shops, only:[:create]
  #end

  get 'maps/index'
  get 'tags/:tag_name', to: 'tops#index', as: :tag
  get "tops/index" => "tops#index"
  get "tops/about" => "tops#about"


  #get "shops/search" => "shops#search"
  #get "shops/shibuya" => "shops#shibuya"
  #get "shops/omotesandou" => "shops#omotesandou"



    #get 'users/:id' => "users#show"
    #よくわからないけれど、"user_path(current_user.id)"が読み込まれなかったから直接リンクを埋め込めるようにしました。

#resources :shops, only:[:index, :show]

  #get 'shops/index' =>"shops#index"
  #get 'shops/:id' => "shops#show"
  #get "reviews/new" => "reviews#new"
  #post "reviews/new" => "reviews#create"
  #get "reviews/:id/edit" =>"reviews#edit"
  #patch "reviews/:id" => "reviews#update"









  #POIUNT→index.html.erb等のhtmlの画面でのリンクを作った際に"/"を始めに打ち込まないと
  #"shops/reviews/new"になってしまう。

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
