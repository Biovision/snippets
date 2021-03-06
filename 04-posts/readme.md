Публикации
==========

Версия 0.1.0 (161030)

Важный момент! Если в проекте уже используется bootstrap, нужно убрать ссылки
на него из `app/views/shared/_summernote.html.erb`

ToDo
----

 * Список публикаций пользователя в админке
 * Список публикаций пользователя в профиле
 * Вынос обработчиков summernote в параметры
 * Управление иллюстрациями

Добавления в `config/routes.rb`
-------------------------------

```ruby
  # Collections that have tags and archive (e.g. posts and dreams)
  concern :tagged_archive do
    collection do
      get 'tagged/:tag_name' => :tagged, as: :tagged
      get 'archive/(:year)/(:month)' => :archive, as: :archive, constraints: { year: /\d{4}/, month: /(\d|1[0-2])/ }
    end
  end

  namespace :admin do
    resources :posts, :tags, only: [:index]
  end

  namespace :api, defaults: { format: :json } do
    resources :posts, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :illustrations, only: [:create, :destroy]
  end

  namespace :my do
    resources :posts, only: [:index]
  end

  resources :posts, concerns: [:tagged_archive]
  resources :figures, only: [:show, :edit, :update, :destroy]
  resources :tags
```

Добавления в `app/helpers/application_helper.rb`
-------------------------------------------------

```ruby
  # @param [Integer] year
  # @param [Integer] month
  def title_for_archive(year, month)
    if year && month
      month_name = t('date.nominative_months')[month.to_i]
      t('archive_month', year: year.to_i, month: month_name)
    elsif year
      t('archive_year', year: year.to_i)
    else
      ''
    end
  end
```

Добавления в `spec/factories/users.rb`
--------------------------------------

```ruby
    factory :chief_editor do
      after :create do |user|
        create :user_role, user: user, role: :chief_editor
      end
    end

    factory :editor do
      after :create do |user|
        create :user_role, user: user, role: :editor
      end
    end
```

Добавления в модели
-------------------

### `app/models/agent.rb`

```ruby
has_many :posts, dependent: :nullify
```

### `app/models/users.rb`

```ruby
has_many :posts, dependent: :destroy
has_many :illustrations, dependent: :nullify
```
