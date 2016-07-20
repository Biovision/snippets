Публикации
==========

В процессе разработки

ToDo
----

 * Разбор текста публикации
 * Предварительный просмотр текста публикации

Добавления в `config/routes.rb`
-------------------------------

```ruby
```

Добавиления в `app/helpers/application_helper.rb`
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

Добавленные роли
----------------

```yaml
chief_editor: "Главный редактор"
editor: "Редактор"
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
