Пользователи с авторизацией через соцсети
=========================================

Версия 0.1.2 (160628)

ToDo
----

 * Локализация в `app/views/code_sender/*`
 * Список жетонов пользователя на его странице в админке
 * Список жетонов текущего пользователя (`/my/tokens`)
 * Стили по умолчанию (`assets/stylesheets/*`)
 * Переключатели состояния (`post /api/users/:id/toggle`, `post /api/tokens/:id/toggle`)
 * Разметка schema.org для профиля
 * Разметка opengraph для профиля
 * Выбор пользователя для `owner_for_entity`
 * Экспорт и импорт пользователей, жетонов и кодов

Дополнения в `Gemfile`
----------------------

```ruby    
# Backport from rails 5
gem 'has_secure_token'

# Processing images
gem 'mini_magick'

# Attaching uploaded files to models
gem 'carrierwave'
gem 'carrierwave-bombshelter'

# Аутентификация через OAuth
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
```

Дополнения в `app/controllers/application_controller.rb`
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
    current_user.is_a?(User) && current_user.has_role?(*role)
  end

  protected

  # Ограничить доступ для анонимных посетителей
  def restrict_anonymous_access
    redirect_to login_path, alert: t(:please_log_in) unless current_user.is_a? User
  end

  # Для доступа необходимо наличие роли у пользователя
  #
  # Неавторизованных пользователей перенаправляет на главную страницу.
  # Анонимным посетителям предлагается выполнить вход.
  #
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
```

Дополнения в `config/routes.rb`
-------------------------------

```ruby
  # Модуль пользователя
  resources :users, except: [:index]
  resources :tokens, :codes, except: [:index]

  # Аутентификация
  controller :authentication do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
    get 'auth/:provider' => :auth_external, as: :auth_external
    get 'auth/:provider/callback' => :callback, as: :auth_callback
  end

  # Личный кабинет пользователя
  namespace :my do
    resource :profile, except: [:destroy]
    resource :confirmation, :recovery, only: [:show, :create, :update]

    get '/' => 'index#index'
  end

  # Администрирование
  namespace :admin do
    get '/' => 'index#index'
    
    resources :users, :tokens, :codes, only: [:index]
  end

  # Публичный профиль пользователя
  scope 'u/:slug', controller: :profiles do
    get '/' => :show, as: :user_profile
  end
```

Дополнения в `config/secrets.yml`
---------------------------------

```yaml
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
```
