source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'sqlite3', '~> 1.4'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'

gem 'omniauth-auth0', '~> 2.5'
gem 'omniauth-rails_csrf_protection', '~> 0.1'

gem "rolify"

gem "rqrcode", "~> 2.0"

gem "simple_calendar", "~> 2.4"
gem "chartkick"
gem 'groupdate'

gem "graphql"

gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails'

  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'

  gem 'rubocop'
  gem 'rubocop-rails'
end

group :test do
  gem 'rspec'

  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  gem 'simplecov'
  gem 'simplecov-lcov', '~> 0.8.0'

  gem 'timecop'
end

gem 'tzinfo-data'
gem 'graphiql-rails', group: [:development, :test]
