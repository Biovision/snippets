Синхронизация для comunit
=========================

Добавления в `config/routes.rb`
-------------------------------

```ruby
  namespace :network, defaults: { format: :json } do
    controller :sites do
      put 'sites/:id' => :synchronize, as: :synchronize_site
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
