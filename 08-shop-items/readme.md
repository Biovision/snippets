Товары магазина
===============

Управление товарами, которые имеют тип, категорию и производителя.
Управление производителями.

Категории следует брать из соответствующего блока (`06-categories`).

Версия 0.1.0 (160920)

Todo
----

 * Страница для посетителей: производители
 * Страница товара для посетителей
 * Список товаров производителя для посетителей
 * Фильтр товаров в админке
 * Фильтр товаров на морде
 
Добавления в `app/models/category.rb`
-------------------------------------

```ruby
  has_many :items, dependent: :destroy
```

Добавления в `spec/controllers/categories_controller_spec.rb`
-------------------------------------------------------------

```ruby
  describe 'get items' do
    before :each do
      allow(entity.class).to receive(:find).and_call_original
      allow(Item).to receive(:page_for_administration)
      allow(subject).to receive(:require_role)
      get :items, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'
    it_behaves_like 'entity_finder'

    it 'sends :page_for_administration to Item' do
      expect(Item).to have_received(:page_for_administration)
    end
  end
```

Добавления в `config/routes.rb`
-------------------------------

```ruby
  concern :list_of_items do
    member do
      get 'items'
    end
  end

  resources :brands, except: [:index, :show]
  resources :item_types, except: [:index, :show]
  resources :items, except: [:index, :show]

  namespace :admin do
    resources :brands, only: [:index, :show], concerns: [:list_of_items]
    resources :item_types, only: [:index, :show], concerns: [:list_of_items]
    resources :items, only: [:index, :show]
  end
  
  namespace :api, defaults: { format: :json } do
    resources :brands, except: [:new, :edit], concerns: [:toggleable, :lockable, :changeable_priority]
    resources :item_types, except: [:new, :edit], concerns: [:lockable]
    resources :items, except: [:new, :edit], concerns: [:toggleable, :lockable, :changeable_priority]
  end
```
