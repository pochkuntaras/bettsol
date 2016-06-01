lock '3.5.0'

set :rvm_type, :system
set :rvm_ruby_version, 'ruby-2.2.3@bettsol'
set :repo_url, 'deploy@localhost:/var/repos/bettsol.git'
set :application, 'bettsol'
set :deploy_to, '/home/deploy/bettsol'
set :deploy_user, 'deploy'
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/private_pub.yml',
                                                 'config/private_pub_thin.yml', 'config/application.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
                                               'public/system', 'public/uploads')

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml restart'
        end
      end
    end
  end
end

after 'deploy:finished', 'private_pub:restart'
after 'deploy:finished', 'thinking_sphinx:index'
after 'deploy:finished', 'thinking_sphinx:restart'
