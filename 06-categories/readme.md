Категории
=========

В процессе

ToDo
----



Добавления в `config/routes.rb`
-------------------------------

```ruby
  resources :categories, except: [:index]

  namespace :admin do
    resources :categories, only: :index
  end
```
