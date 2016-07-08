Комментарии к комментируемому
=============================

Версия 0.1.0 (160707)

ToDo
----

 * CSS и вёрстка по умолчанию
 * API-часть (скрытие/отображение)
 * Отправка уведомлений в рамках сайта
 * Локализация для писем
 * Предварительный просмотр текста комментария
 * Проверка видимости комментария

Дополнения к `config/routes.rb`
------------------------

```ruby
  resources :comments, except: [:index, :new]

  namespace :admin do
    resources :comments, only: [:index]
  end

  namespace :api, defaults: { format: :json } do
    resources :comments, except: [:new, :edit]
  end
  
  namespace :my do
    resources :comments, only: [:index]
  end
```

Обратить внимание в `app/views/comments/entry_reply*`
-----------------------------------------------------

В представлениях используются методы помощника `ParsingHelper`
из компонента с публикациями.

Сайт по умолчанию указан как `example.com`, нужно поменять 
на актуальный.
