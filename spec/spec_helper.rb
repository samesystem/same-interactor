# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  add_filter(/_spec.rb\Z/)
end

require 'same/interactor'

if ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
require 'pry'
require 'pry-nav'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
