Заказы в магазине
=================

Версия 0.0.0 (161018)

Добавления в `app/models/item.rb`
---------------------------------

```ruby
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
```

Добавления в `config/routes.rb`
-------------------------------

