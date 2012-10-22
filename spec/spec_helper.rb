# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'pp'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Capybara.default_host = 'http://example.org'
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
#  config.order = "random"

  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

shared_context "twitter_login" do
  let!(:user) { FactoryGirl.create(:user) }
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[user.provider.to_sym] = {
      "provider" => user.provider,
      "uid" => user.uid, 
      "info" => { "name" => user.name }
    }

    visit "/auth/twitter"
  end
end

shared_context "login_stub" do
  let!(:user) { FactoryGirl.create(:user) }
  before do
    controller.stub(:login_required) { true }
    controller.stub(:current_user) { user }
  end
end
