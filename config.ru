# frozen_string_literal: true

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  gem 'debug'
  gem 'rails', '>= 7.1'
  gem 'sqlite3', '~> 1.4'
end

require 'rails/all'
database = 'development.sqlite3'

ENV['DATABASE_URL'] = "sqlite3:#{database}"

class App < Rails::Application
  config.load_defaults 7.0
  config.eager_load = false
  config.active_record.run_after_transaction_callbacks_in_order_defined = true
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
# ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
  end
end

App.initialize!

puts "RUN AFTER TRANSACTION CALLBACKS IN ORDER DEFINED: #{ActiveRecord.run_after_transaction_callbacks_in_order_defined}"

class Post < ActiveRecord::Base
  after_commit -> { puts("FOO") }
  after_commit -> { puts("BAR") }
end

Post.create!
