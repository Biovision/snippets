Empty rails
===========

Локализация и настройки пумы для нового rails-приложения

Дополнительные куски
--------------------

Добавления в `Gemfile`

```ruby
gem 'kaminari'
gem 'rails-i18n', '~> 4.0.0'
gem 'puma'

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

```ruby
config.time_zone = 'Moscow'

config.i18n.enforce_available_locales = true
config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
config.i18n.default_locale = :ru

%w(app/services lib).each do |path|
  config.autoload_paths << config.root.join(path).to_s
end

config.action_dispatch.rescue_responses.merge!(
    {
        :'ApplicationController::UnauthorizedException' => :unauthorized,
        :'ApplicationController::ForbiddenException' => :forbidden,
    }
)
```

Добавления в `spec/rails_helper.rb` (`$ rails generate rspec:install`)

```ruby
config.include FactoryGirl::Syntax::Methods
```

Добавления в `app/controllers/application_controller.rb`

```ruby
class UnauthorizedException < Exception
end

class ForbiddenException < Exception
end

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
```

Добавления в `app/helpers/application_helper.rb`

```ruby
def link_to_delete(entity)
  link_to t(:delete), entity, method: :delete, data: { confirm: t(:are_you_sure) }
end
```
