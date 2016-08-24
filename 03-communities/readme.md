Сообщества
==========

В процессе разработки.

Добавления в `app/models/agent.rb`
----------------------------------

```ruby
    has_many :communities, dependent: :nullify
```
