source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.4'

# gem 'turbo-rails', '~> 2.0.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1.3.4'
# Use Puma as the app server
gem 'puma', '~> 6.4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'shakapacker', '~> 8.0.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.12.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'graphql-client'

gem 'feedjira', '~> 3.2.3'

gem 'rack-attack'
# Logger
gem 'bitquery_logger', git: 'https://github.com/bitquery/bitquery_logger.git', tag: 'v0.7.9' # , path: '../bitquery_logger'
gem 'exception_notification'
gem 'exception_notification-rake', '~> 0.3.1'
gem 'lograge'
gem 'logstash-event'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18.3', require: false

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.9.0'
  gem 'web-console', '~> 4.2.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'better_errors', '~> 2.10.1'
  gem 'binding_of_caller', '~> 1.0.1'
  gem 'rubocop', '~> 1.64.1', require: false
  gem 'rubocop-performance', '~> 1.21.1', require: false
  gem 'rubocop-rails', '~> 2.25.0', require: false
  gem 'spring', '~> 4.2.1'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
# , platforms: %i[mingw mswin x64_mingw jruby]

# Use Capistrano for deployment
group :development, :test do
  gem 'capistrano', '~> 3.19.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  # gem 'capistrano-rvm'
  gem 'dotenv-rails', '~> 3.1.2'
  gem 'sshkit-sudo'
end

# Monitoring
gem 'yabeda-graphql'
gem 'yabeda-http_requests'
gem 'yabeda-prometheus-mmap'
gem 'yabeda-puma-plugin'
gem 'yabeda-rails'

# Find all missing translations
# gem 'i18n-tasks', '~> 1.0.12'

gem 'sprockets', '~> 4.2.0'

gem 'websocket-client-simple', '~> 0.9.0'
