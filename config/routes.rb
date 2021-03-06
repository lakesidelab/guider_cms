GuiderCms::Engine.routes.draw do



  get '/guider_index', to: 'articles#index', as: 'guider_home'

  get '/category/new', to: 'categories#new', as: 'new_optimized_category'

  get '/your_articles', to: 'current_user_articles#index', as: 'user_articles'

  get '/your_articles/:root/:selected_category/:id', to: 'articles#show', as: 'user_article'

  get '/:root/create_new_subcategories', to: 'subcategories#new', as: 'new_subcategory'


  get '/root_categories', to: 'categories#index', as: 'root_categories'

  get 'categories/:id/edit', to: 'categories#edit', as: 'edit_categories'


  # :root_category/:category

  # get '/:root/:selected_category/:id/edit', to: 'articles#edit', as: 'edit_content'

  get '/move_higher/:id', to: 'articles#edit_article_position_one_backward', as: 'move_article_backward'

  get '/move_lower/:id', to: 'articles#edit_article_position_one_forward', as: 'move_article_forward'

  get '/:root/new', to: 'articles#new', as: 'new_content'


  get '/:root/:id/edit', to: 'articles#edit', as: 'root_content_edit'

  get '/:root/', to: 'articles#index', as: 'content_new_back'

  get '/:root/content/:id', to: 'articles#show', as: 'root_articles'

  get '/:root/:selected_category', to: 'articles#index', as: 'contents'


  get '/:root/:selected_category/:id', to: 'articles#show', as: 'content'

  get '/:root/:selected_category/:id/edit', to: 'articles#edit', as: 'edit_content'

  resources :categories

  resources :subcategories

  resources :articles

  get 'user_articles', to: 'current_user_articles#index'

end
