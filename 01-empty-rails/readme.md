Empty rails
===========

Локализация, CSS, JS и настройки пумы и почты для нового rails-приложения

Версия 1.0.0 (160916)

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
config.time_zone = 'Moscow'

config.i18n.enforce_available_locales = true
config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
config.i18n.default_locale = :ru

%w(app/services lib).each do |path|
  config.autoload_paths << config.root.join(path).to_s
end
```

Добавления в `spec/rails_helper.rb` (`$ rails generate rspec:install`)
----------------------------------------------------------------------

```ruby
config.include FactoryGirl::Syntax::Methods
```

Добавления в `spec/spec_helper.rb`
----------------------------------

```ruby
  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
```

Добавления в `app/controllers/application_controller.rb`
--------------------------------------------------------

```ruby
    helper_method :current_page, :param_from_request
    
    # Получить текущую страницу из запроса
    #
    # @return [Integer]
    def current_page
      @current_page ||= (params[:page] || 1).to_s.to_i.abs
    end
    
    # Получить параметр из запроса и нормализовать его
    #
    # Приводит параметр к строке в UTF-8 и удаляет недействительные в UTF-8 символы
    #
    # @param [Symbol] parameter
    # @return [String]
    def param_from_request(parameter)
      params[parameter].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
    end

    protected

    # Обёртка для исключения «Запись не найдена»
    #
    # @return [ActiveRecord::RecordNotFound]
    def record_not_found
      ActiveRecord::RecordNotFound
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
