require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'bettsol', url: 'redis://127.0.0.1:6379/1' }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'bettsol', url: 'redis://127.0.0.1:6379/1' }
end
