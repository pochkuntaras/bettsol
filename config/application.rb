require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(*Rails.groups)

module Bettsol
  class Application < Rails::Application
    config.i18n.default_locale = :en
    config.sass.preferred_syntax = :sass
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.test_framework :rspec, fixtures: true, view_specs: false,
                       helper_specs: false, routing_specs: false,
                       request_specs: false, controller_specs: true

      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
