Социализация
============

Следование пользователей друг за другом и обмен сообщениями
между пользователями.

Версия 0.1.0 (161123)

ToDo
----

 * Список друзей пользователя
 * Фильтр в списках друзей
 * Друзья онлайн
 * Сохранение/восстановление данных
 * Бан/игнорирование
 
Добавления в `config/routes.rb`
-------------------------------

```ruby
  resources :user_messages, only: [:create, :destroy]

  namespace :my do
    resources :followers, :followees, only: [:index]
    resources :messages, only: [:index] do
      get '/:user_slug' => :dialog, on: :collection, as: :dialog
    end
  end
  
  namespace :api, defaults: { format: :json } do
    resources :user_links, except: [:new, :edit], concerns: [:toggleable]
  end
```

Добавления в `app/models/user.rb`
---------------------------------

```ruby
  has_many :follower_links, class_name: UserLink.to_s, foreign_key: :followee_id, dependent: :destroy
  has_many :followee_links, class_name: UserLink.to_s, foreign_key: :follower_id, dependent: :destroy
  has_many :sent_messages, class_name: UserMessage.to_s, foreign_key: :sender_id, dependent: :destroy
  has_many :received_messages, class_name: UserMessage.to_s, foreign_key: :receiver_id, dependent: :destroy


  # @param [User] user
  def follows?(user)
    UserLink.where(follower: self, followee: user).exists?
  end
```

Добавления в `app/views/profiles/_profile.html.erb`
---------------------------------------------------

В таблицу с данными перед картинкой пользователя.

```html
    <% if current_user.is_a?(User) && (current_user != user) %>
        <thead>
        <tr>
          <td colspan="2">
            <div class="user-actions">
              <%= render partial: 'users/follow_buttons', locals: { user: user, followee: current_user.follows?(user) } %>
              <div><%= link_to t('user_messages.new.heading'), dialog_my_messages_path(user_slug: user.long_slug), class: 'navigation-button' %></div>
            </div>
          </td>
        </tr>
        </thead>
    <% end %>
```

Добавления в `app/views/my/index/index.html.erb`
------------------------------------------------

В список ссылок.

```html
        <li>
          <div>
            <%= link_to t('my.messages.index.heading'), my_messages_path %>
          </div>
          <div class="description">
            <%= t('my.messages.index.description') %>
          </div>
        </li>
        <li>
          <div>
            <%= link_to t('my.followers.index.heading'), my_followers_path %>
          </div>
          <div class="description">
            <%= t('my.followers.index.description') %>
          </div>
        </li>
        <li>
          <div>
            <%= link_to t('my.followees.index.heading'), my_followees_path %>
          </div>
          <div class="description">
            <%= t('my.followees.index.description') %>
          </div>
        </li>
```

Если в пользователе нет счётчиков дружбы
----------------------------------------

Нужно добавить миграцию: `rails g migration add_link_fields_to_users`

```ruby
    add_field :users, :follower_count, :integer, null: false, default: 0
    add_field :users, :followee_count, :integer, null: false, default: 0
```