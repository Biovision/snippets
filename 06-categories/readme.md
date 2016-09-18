Категории
=========

Версия 1.0.0 (160917)

Добавления в `config/routes.rb`
-------------------------------

```ruby
  resources :categories, except: [:index]

  namespace :admin do
    resources :categories, only: :index
  end
  
  namespace :api, defaults: { format: :json } do
    resources :categories, except: [:new, :edit], concerns: [:toggleable, :lockable, :changeable_priority]
  end
```
