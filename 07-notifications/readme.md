Уведомления на сайте
====================

Версия 0.1.0 (161123)

Тип уведомления определяется атрибутом `category` из списка.
В `payload` хранится id связанного объекта (например, комментария).

ToDo
----

 * Получение уведомлений в API
 
Добавления в `config/routes.rb`
-------------------------------

```ruby
  namespace :api, defaults: { format: :json } do
    resources :notifications, only: [:destroy]
  end

  namespace :my do
    resources :notifications, only: [:index]
  end
```
