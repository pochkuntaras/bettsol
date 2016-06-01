server 'server', user: 'deploy', roles: %w{app web db}, primary: true

role :app, %w{deploy@server}
role :web, %w{deploy@server}
role :db,  %w{deploy@server}

set :rails_env, :production
set :stage, :production
set :ssh_options, keys: %w(/home/taras/.ssh/id_rsa), forward_agent: true, auth_methods: %w(publickey password)

set :sidekiq_role, :app
set :sidekiq_queue, [:default, :mailers]
