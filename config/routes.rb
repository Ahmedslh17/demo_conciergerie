Rails.application.routes.draw do
  root "pages#home"
  post "leads", to: "pages#create_lead"

  get "admin", to: "pages#admin", as: :admin
  delete "leads/:id", to: "pages#destroy_lead", as: :delete_lead
  
  get "logout", to: "pages#logout", as: :logout
end