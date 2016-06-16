Комментарии к комментируемому
=============================

В процессе.

ToDo
----

 * контроллер для добавления
 * контроллер в админке
 * API-часть (скрытие/отображение)

Дополнения к `config/routes.rb`
------------------------

```ruby
  resources :comments, except: [:index]

  namespace :admin do
    resources :comments, only: [:index]
  end

  namespace :api do
    resources :comments
  end
```
