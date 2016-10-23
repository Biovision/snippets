Заказы в магазине
=================

Версия 0.1.0 (161023)

_Важный момент!_ 
Чтобы корзина не отваливалась вместе с зактырием окна браузера,
нужно выставить подходящее время жизни сессии. Для этого следует добавить 
в `config/initializers/session_store.rb` параметр `expire_after: 2.weeks`
(или любой другой) в той же строке, где название куки и тип хранилища.

Добавления в `app/models/item.rb`
---------------------------------

```ruby
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
```

Добавления в `app/models/agent.rb`
----------------------------------

```ruby
  has_many :orders, dependent: :nullify
```

Добавления в `config/routes.rb`
-------------------------------

```ruby
  resources :orders, only: [:edit, :update, :destroy]
  resource :cart, except: [:create] do
    get 'result'
  end

  namespace :admin do
    resources :orders, only: [:index, :show]
  end

  namespace :api, defaults: { format: :json } do
    scope 'cart', controller: :cart do
      get '/' => :show
      post 'items' => :add_item
      delete 'items/:id' => :remove_item
    end
  end
```

Фрагмент шаблона для вывода «краткой корзины»
---------------------------------------------

```html
  <div id="cart-brief">
    <div><%= link_to t('.cart'), cart_path %></div>
    <div><span class="items-count"><%= t(:item, count: 0) %></span></div>
    <div><span class="price">0</span></div>
  </div>
```
