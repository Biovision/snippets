Пользователи с авторизацией через соцсети
=========================================

ToDo
----

 * Локализация в `app/views/code_sender/*`
 * Список жетонов пользователя на его странице в админке
 * Список жетонов текущего пользователя (`/my/tokens`)
 * Стили по умолчанию (`assets/stylesheets/*`)
 * Переключатели состояния (`post /users/:id/toggle`)
 * Разметка schema.org для профиля
 * Разметка opengraph для профиля

Дополнения в `Gemfile`
----------------------

```ruby    
# Backport from rails 5
gem 'has_secure_token'

# Processing images
gem 'mini_magick'

# Attaching uploaded files to models
gem 'carrierwave'

# Аутентификация через OAuth
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
```

Дополнения в `config/routes.rb`
-------------------------------

```ruby
  # Административные ресурсы
  resources :users, :tokens, :codes

  # Аутентификация
  controller :authentication do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
    get 'auth/:provider' => :auth_external, as: :auth_external
    get 'auth/:provider/callback' => :callback, as: :auth_callback
  end

  namespace :my do
    resource :profile, except: [:destroy]
    resource :confirmation, :recovery, only: [:show, :create, :update]

    get '/' => 'index#index'
  end

  # Профиль пользователя
  scope 'u/(:slug)', controller: :users do
    get '/' => :profile, as: :user_profile
  end
```

Дополнения в `config/secrets.yml`
---------------------------------

      mail_password: secret
      vkontakte:
        app_id: 
        app_secret: 
        redirect_uri: http://example.local:3000/auth/vkontakte/callback
      twitter:
        api_key: 
        api_secret: 
      facebook:
        app_id: 
        app_secret: 

Дополнения в `config/environments/production.rb`
------------------------------------------------

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'example.com',
      user_name: 'support@example.com',
      password: Rails.application.secrets.mail_password,
      authentication: :plain,
      enable_starttls_auto: true
  }
  config.action_mailer.default_options = {
      from: 'example.com <support@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { host: 'example.com' }
```

Дополнения в `config/environments/test.rb` и `config/environments/development.rb`
---------------------------------------------------------------------------------

```ruby
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_options = {
      from: 'example.com <support@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { :host => '0.0.0.0:3000' }
```

