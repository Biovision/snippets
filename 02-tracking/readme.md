Браузеры и агенты пользователя
==============================

В процессе.

Добавления в `app/controllers/application_controller.rb`
--------------------------------------------------------

```ruby

  def agent
    @agent ||= Agent.for_string(request.user_agent || 'n/a')
  end

  def tracking_for_entity
    { agent: agent, ip: request.env['HTTP_X_REAL_IP'] || request.remote_ip }
  end

```