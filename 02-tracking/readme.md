Браузеры и агенты пользователя
==============================

В процессе.

ToDo
----

 * Администрирование браузеров и агентов
 * Запирание/отпирание (put/delete lock)
 * Переключение состояний (post toggle)
 * Отображение данных для объекта
 * Работа с подсетями (чёрные списки IP и так далее)

Добавления в `app/controllers/application_controller.rb`
--------------------------------------------------------

```ruby

  def agent
    @agent ||= Agent.for_string(request.user_agent || 'n/a')
  end

  def tracking_for_entity
    { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
  end

```

Добавления в `config/routes.rb`
-------------------------------

```ruby
  concern :toggleable do
    post 'toggle', on: :member
  end

  concern :lockable do
    member do
      put 'lock', as: :lock
      delete 'lock', as: :unlock
    end
  end

  namespace :admin do
    resources :browsers, :agents, only: :index
  end

  namespace :api, defaults: { format: :json } do
    resources :browsers, :agents, concerns: [:toggleable, :lockable]
  end

  resources :browsers, except: [:index] do
    member do
      get 'agents'
    end
  end
  resources :agents, except: [:index]
```
