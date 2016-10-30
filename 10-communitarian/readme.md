Communitarian
=============

В процессе разработки

Добавления в `config/routes.rb`
-------------------------------

```ruby
  category_pattern = /(?!new$|^\d+$)[-_a-z0-9]+[a-z_]/

  resources :news_categories, :post_categories, except: [:index, :show]

  resources :news, except: [:show] do
    collection do
      get ':category_slug' => :category, as: :category, constraints: { category_slug: category_pattern }
      get ':category_slug/:slug' => :show, as: :news_in_category, constraints: { category_slug: category_pattern }
    end
  end
  resources :posts, except: [:show], concerns: [:tagged_archive] do
    collection do
      get ':category_slug' => :category, as: :category, constraints: { category_slug: category_pattern }
      get ':category_slug/:slug' => :show, as: :post_in_category, constraints: { category_slug: category_pattern }
    end
  end

  resources :regions, except: [:index, :show]
  resources :themes, except: [:index, :show]

  namespace :admin do
    resources :news_categories, :post_categories, only: [:index, :show] do
      get 'items', on: :member
    end
    resources :news, only: [:index, :show]
    resources :posts, :tags, only: [:index, :show]
    resources :regions, only: [:index, :show]
    resources :themes, only: [:index, :show]
  end

  namespace :api, defaults: { format: :json } do
    resources :news_categories, :post_categories, except: [:new, :edit], concerns: [:toggleable, :lockable, :changeable_priority]
    resources :news, :posts, except: [:new, :edit], concerns: [:toggleable, :lockable] do
      put 'category', on: :member
    end
    resources :regions, except: [:new, :edit], concerns: [:lockable]
    resources :themes, except: [:new, :edit], concerns: [:lockable] do
      member do
        put 'post_categories/:category_id' => :add_post_category, as: :post_category
        delete 'post_categories/:category_id' => :remove_post_category
        put 'news_categories/:category_id' => :add_news_category, as: :news_category
        delete 'news_categories/:category_id' => :remove_news_category
      end
    end
  end
```