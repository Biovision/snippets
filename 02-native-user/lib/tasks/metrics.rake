namespace :metrics do
  desc 'Collect new data for metrics'
  task update: :environment do
    Metric.register(User::METRIC_COUNT, User.count)
    Metric.register(Agent::METRIC_COUNT, Agent.count)
    Metric.register(Token::METRIC_COUNT, Token.count)
  end
end
