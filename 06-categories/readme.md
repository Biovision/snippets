Категории
=========

Версия 1.0.1 (161010)

Добавления в `config/routes.rb`
-------------------------------

```ruby
  resources :categories, except: [:index, :show]

  namespace :admin do
    resources :categories, only: [:index, :show]
  end
  
  namespace :api, defaults: { format: :json } do
    resources :categories, except: [:new, :edit], concerns: [:toggleable, :lockable, :changeable_priority]
  end
```
