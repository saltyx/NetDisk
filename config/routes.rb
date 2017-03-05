Rails.application.routes.draw do
  namespace :v1 do
    post 'login/', to: 'login#index'
    post 'upload/:id', to: 'file#upload'
    post 'upload_big_file/:id', to: 'file#upload_big_file'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
