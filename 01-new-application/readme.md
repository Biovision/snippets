New application
===============

Локализация, CSS, JS и почты для нового rails-приложения, а также метрики
и начальная версия модуля пользователей.

Версия 1.1.0 (161020)

Не забудь отредактировать `.env`, девелопернейм!

ToDo
----

 * Локализация в `app/views/code_sender/*`
 * Список жетонов текущего пользователя (`/my/tokens`)
 * Разметка schema.org для профиля
 * Разметка opengraph для профиля
 * Выбор пользователя для `owner_for_entity`
 * Работа с подсетями (чёрные списки IP и так далее)
 * Поиск пользователя через AJAX


Добавления в `.gitignore`
-------------------------

```
/public/uploads

/spec/examples.txt
/spec/support/uploads/*

.env
```

Добавления в `Gemfile`
----------------------

```ruby
gem 'dotenv-rails'

gem 'autoprefixer-rails', group: :production

gem 'kaminari'
gem 'rails-i18n', '~> 5.0.0'

gem 'mini_magick'
gem 'carrierwave', git: 'https://github.com/carrierwaveuploader/carrierwave'
gem 'carrierwave-bombshelter'

gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :development do
  gem 'mina'
end
```

Добавления в `config/application.rb`
------------------------------------

```ruby
  class Application < Rails::Application
    config.time_zone = 'Moscow'

    config.i18n.enforce_available_locales = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ru

    %w(app/services lib).each do |path|
      config.autoload_paths << config.root.join(path).to_s
    end
  end
```

Добавления в `spec/rails_helper.rb` (`$ rails generate rspec:install`)
----------------------------------------------------------------------

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
```

Добавления в `spec/spec_helper.rb`
----------------------------------

```ruby
RSpec.configure do |config|
  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
end
```

Добавления в `app/controllers/application_controller.rb`
--------------------------------------------------------

```ruby
  helper_method :current_page, :param_from_request
  helper_method :current_user, :current_user_has_role?
    
  # Получить текущую страницу из запроса
  #
  # @return [Integer]
  def current_page
    @current_page ||= (params[:page] || 1).to_s.to_i.abs
  end
    
  # Получить параметр из запроса и нормализовать его
  #
  # Приводит параметр к строке в UTF-8 и удаляет недействительные символы
  #
  # @param [Symbol] param
  # @return [String]
  def param_from_request(param)
    params[param].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
  end

  # Получить текущего пользователя из жетона доступа в куки
  #
  # @return [User|nil]
  def current_user
    @current_user ||= Token.user_by_token cookies['token'], true
  end

  # @param [Symbol] role
  def current_user_has_role?(*role)
    UserRole.user_has_role? current_user, *role
  end

  protected

  # Обёртка для исключения «Запись не найдена»
  #
  # @return [ActiveRecord::RecordNotFound]
  def record_not_found
    ActiveRecord::RecordNotFound
  end

  # Ограничить доступ для анонимных посетителей
  def restrict_anonymous_access
    redirect_to login_path, alert: t(:please_log_in) unless current_user.is_a? User
  end

  # @param [Symbol] role
  def require_role(*role)
    if current_user.is_a? User
      redirect_to root_path, alert: t(:insufficient_role) unless current_user.has_role? *role
    else
      redirect_to login_path, alert: t(:please_log_in)
    end
  end

  # Информация о текущем пользователе для сущности
  def owner_for_entity
    { user: current_user }
  end

  def agent
    @agent ||= Agent.named(request.user_agent || 'n/a')
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
      put 'lock'
      delete 'lock', action: :unlock
    end
  end

  concern :changeable_priority do
    post 'priority', on: :member
  end

  root 'index#index'

  resources :browsers, :agents, except: [:index, :show]
  
  resources :users, except: [:index, :show]
  resources :tokens, :codes, except: [:index, :show]

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

  namespace :admin do
    get '/' => 'index#index'
    
    resources :metrics, only: [:index, :show]

    resources :browsers, only: [:index, :show] do
      get 'agents', on: :member
    end
    resources :agents, only: [:index, :show]

    resources :users, only: [:index, :show] do
      member do
        get 'tokens'
        get 'codes'
      end
    end
    resources :tokens, :codes, only: [:index, :show]
  end

  namespace :api, defaults: { format: :json } do
    resources :users, :tokens, except: [:new, :edit], concerns: [:toggleable]
    resources :browsers, :agents, except: [:new, :edit], concerns: [:toggleable, :lockable]
  end

  scope 'u/:slug', controller: :profiles do
    get '/' => :show, as: :user_profile
  end
```


Дополнения в `config/environments/production.rb`
------------------------------------------------

Вариант для `gmail.com`

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'example.com',
      user_name: 'support@example.com',
      password: ENV['MAIL_PASSWORD'],
      authentication: :plain,
      enable_starttls_auto: true
  }
  config.action_mailer.default_options = {
      from: 'example.com <support@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { host: 'example.com' }
```

Вариант для `mail.ru`

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'smtp.mail.ru',
      port: 465,
      tls: true,
      domain: 'example.com',
      user_name: 'support@example.com',
      password: ENV['MAIL_PASSWORD'],
      authentication: :login,
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
