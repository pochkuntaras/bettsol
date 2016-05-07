FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name 'TestApplication'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    uid { rand 1000..2000 }
    secret { rand 2000..4000 }
  end
end
