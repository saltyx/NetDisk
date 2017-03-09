Rails.application.routes.draw do

  namespace :v1 do
    post 'login/', to: 'login#index'

    post 'upload/:id', to: 'upload#upload'
    post 'upload_big_file/:id', to: 'upload#upload_big_file'

    post 'folder/create', to: 'folder#create'
    delete 'folder/delete', to: 'folder#delete'
    put 'folder/update', to: 'folder#update'
    post 'folder/encrypt', to: 'folder#encrypt'
    post 'folder/decrypt', to: 'folder#decrypt'
    get 'folder/:id', to: 'folder#files_by_folder'

    post 'file/encrypt', to: 'file#encrypt'
    post 'file/decrypt', to: 'file#decrypt'
    post 'file/copy', to: 'file#copy'
    delete 'file/delete',to: 'file#delete'
    put 'file/move', to: 'file#move'
    post 'file/share', to: 'file#share'
    post 'file/share/cancel', to: 'file#cancel_sharing'

  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
