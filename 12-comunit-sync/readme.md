Синхронизация для comunit
=========================

Добавления в `config/routes.rb`
-------------------------------

```ruby
  namespace :network, defaults: { format: :json } do
    controller :sites do
      put 'sites/:id' => :synchronize, as: :synchronize_site
    end
    scope 'users', controller: :users do
      put ':id' => :synchronize, as: :synchronize_user
    end
  end
```

Добавления в `config/secrets.yml`
---------------------------------

```yaml
development:
  signature_token: 

test:
  signature_token:

production:
  signature_token: <%= ENV["SIGNATURE_TOKEN"] %>
```

Добавления в `app/models/user.rb`
---------------------------------

```ruby
  OLD_SLUG_PATTERN  = /\A[-a-z0-9_а-яё@&*. ]{3,30}\z/

  def self.synchronization_parameters
    ignored = %w(id)
    column_names.reject { |c| ignored.include?(c) }
  end

  def self.relink_parameters
    ignored = %w(id external_id site_id agent_id image network native_id religion)
    result  = []
    column_names.each do |column|
      next if ignored.include?(column)
      next if column =~ /_count$/
      result << column
    end
    result
  end

  def slug_should_be_valid
    if native?
      pattern = legacy_slug? ? OLD_SLUG_PATTERN : SLUG_PATTERN
      errors.add(:screen_name, I18n.t('activerecord.errors.models.user.attributes.slug.invalid')) unless slug =~ pattern
    end
  end
```