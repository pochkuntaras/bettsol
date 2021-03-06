require 'rails_helper'
require 'capybara/email/rspec'

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.include AcceptanceMacros, type: :feature
  config.include OmniAuthMacros, type: :feature
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
