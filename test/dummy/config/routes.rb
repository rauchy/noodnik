Rails.application.routes.draw do

  mount Noodnik::Engine => "/noodnik"
  
  root :to => 'home#index'
end
