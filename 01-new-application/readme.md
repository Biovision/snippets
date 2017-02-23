New application
===============

Локализация, CSS, JS и почты для нового rails-приложения, а также метрики
и начальная версия модуля пользователей.

Версия 1.3.0 (170217)

Не забудь отредактировать `.env`, девелопернейм!

Ещё нужно поменять `example.com` на актуальное название.

Также стоит удалить `app/assets/application.css`, так как используется scss,
и локаль `config/locales/en.yml`, если не планируется использование английской
локали.

После установки приложения нужно накатить миграции:

 1. `$ rails railties:install:migrations`
 2. `$ rake db:migrate`

Чтобы не было проблем, миграции из пакетов должны иметь более раннюю дату, 
чем миграции из этого куска. 

ToDo
----

 * Локализация в `app/views/code_sender/*`
 * Список жетонов текущего пользователя (`/my/tokens`)
 * Разметка schema.org для профиля
 * Разметка opengraph для профиля
 * Выбор пользователя для `owner_for_entity`
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

Нужно раскомментировать `bcrypt`

```ruby
gem 'dotenv-rails'

gem 'autoprefixer-rails', group: :production

gem 'rails-i18n', '~> 5.0.0'

gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-bombshelter'

gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'

gem 'biovision-base', git: 'https://github.com/Biovision/biovision-base.git'
gem 'track', git: 'https://github.com/Biovision/track.git'

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :development do
  gem 'mina'
end
```

Добавления в `app/assets/application.js`
----------------------------------------

Это добавляется перед `//= require tree .`

```js
//= require biovision/base/biovision.js
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

    config.assets.precompile << %w(biovision/base/**/*)
  end
```

Добавления в `spec/rails_helper.rb` (`$ rails generate rspec:install`)
----------------------------------------------------------------------

Раскомментировать строку 23 (включение содержимого `spec/support`)

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
  helper_method :current_user, :current_user_has_role?

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
  #
  # @param [Boolean] track
  def owner_for_entity(track = false)
    result = { user: current_user }
    result.merge!(tracking_for_entity) if track
    result
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
  end

  scope 'u/:slug', controller: :profiles do
    get '/' => :show, as: :user_profile
  end
```


Дополнения в `config/environments/production.rb`
------------------------------------------------

Вариант для `mail.ru`

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'smtp.mail.ru',
      port: 465,
      tls: true,
      domain: 'example.com',
      user_name: 'webmaster@example.com',
      password: ENV['MAIL_PASSWORD'],
      authentication: :login,
      enable_starttls_auto: true
  }
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { host: 'example.com' }
```

Вариант для `gmail.com`

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'example.com',
      user_name: 'webmaster@example.com',
      password: ENV['MAIL_PASSWORD'],
      authentication: :plain,
      enable_starttls_auto: true
  }
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { host: 'example.com' }
```

Дополнения в `config/environments/test.rb`
------------------------------------------

```ruby
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { :host => '0.0.0.0:3000' }
```

Дополнения в `config/environments/development.rb`
-------------------------------------------------

```ruby
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { :host => '0.0.0.0:3000' }
```

Дополнения в `config/puma.rb`
-----------------------------

```ruby
if ENV['RAILS_ENV'] == 'production'
  shared_path = '/var/www/example.com/shared'
  logs_dir    = "#{shared_path}/log"

  state_path "#{shared_path}/tmp/puma/state"
  pidfile "#{shared_path}/tmp/puma/pid"
  bind "unix://#{shared_path}/tmp/puma.sock"
  stdout_redirect "#{logs_dir}/stdout.log", "#{logs_dir}/stderr.log", true
  
  activate_control_app
end
```
