Блоги для сети Communitarian
============================

В процессе разработки

Добавления в `config/routes.rb`
-------------------------------

```ruby
  concern :list_of_entries do
    get 'entries', on: :member
  end
  
  resources :entries, concerns: [:tagged_archive]
  
  namespace :my do
    resources :entries, only: [:index]
  end

  namespace :admin do
    resources :entries, only: [:index, :show], concerns: [:list_of_comments]
  end
```

