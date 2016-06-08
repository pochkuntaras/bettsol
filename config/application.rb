require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(*Rails.groups)

module Bettsol
  class Application < Rails::Application
    config.time_zone = 'Kyiv'
    config.i18n.default_locale = :en
    config.sass.preferred_syntax = :sass
    config.assets.precompile = [/^[^_]/]
    config.active_job.queue_adapter = :sidekiq
    config.active_record.raise_in_transactional_callbacks = true
    config.app_generators.scaffold_controller :responders_controller

    config.generators do |g|
      g.test_framework :rspec, fixtures: true, view_specs: false,
                       helper_specs: false, routing_specs: false,
                       request_specs: false, controller_specs: true

      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.cache_store = :redis_store, { host: '127.0.0.1',
                                         port: 6379,
                                         db: 1,
                                         namespace: 'bettsol',
                                         expires_in: 90.minutes }
  end
end
