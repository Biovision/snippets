Пользователи с авторизацией через соцсети и отслеживание
========================================================

Версия 0.3.1 (160914)

ToDo
----

 * Локализация в `app/views/code_sender/*`
 * Список жетонов пользователя на его странице в админке
 * Список жетонов текущего пользователя (`/my/tokens`)
 * Переключатели состояния (`post /api/tokens/:id/toggle`)
 * Тесты для `Api::UsersController`
 * Тесты для `Api::TokensController`
 * Разметка schema.org для профиля
 * Разметка opengraph для профиля
 * Выбор пользователя для `owner_for_entity`
 * Работа с подсетями (чёрные списки IP и так далее)

Дополнения в `Gemfile`
----------------------

```ruby    
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
    UserRole.user_has_role? current_user, *role
  end

  protected

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

Дополнения в `config/routes.rb`
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

  resources :users, except: [:index]
  resources :tokens, :codes, except: [:index]

  resources :browsers, except: [:index] do
    member do
      get 'agents'
    end
  end
  resources :agents, except: [:index]

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
    
    resources :users, :tokens, :codes, only: [:index]
    resources :browsers, :agents, only: :index
  end

  namespace :api, defaults: { format: :json } do
    resources :users, :tokens, except: [:new, :edit], concerns: [:toggleable]
    resources :browsers, :agents, except: [:new, :edit], concerns: [:toggleable, :lockable]
  end

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
  twitter:
    api_key:
    api_secret:
  facebook:
    app_id:
    app_secret:
```
