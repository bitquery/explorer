source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.7.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.1'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'graphql-client'

gem 'feedjira', '~> 3.1', '>= 3.1.2'

# Logger
gem 'bitquery_logger', git: 'https://github.com/bitquery/bitquery_logger.git', branch: 'main'#, path: '../bitquery_logger'
gem 'exception_notification'
gem 'exception_notification-rake', '~> 0.3.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'better_errors', '~> 2.9', '>= 2.9.1'
  gem 'binding_of_caller', '~> 1.0'
  gem 'rubocop', '~> 1.9', '>= 1.9.1', require: false
  gem 'rubocop-performance', '~> 1.9', '>= 1.9.2', require: false
  gem 'rubocop-rails', '~> 2.9', '>= 2.9.1', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
#, platforms: %i[mingw mswin x64_mingw jruby]

# Use Capistrano for deployment
group :development, :test do
  gem 'capistrano', '3.11.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  # gem 'capistrano-rvm'
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
  gem 'sshkit-sudo'
end

# Find all missing translations
# gem 'i18n-tasks', '~> 1.0.12'
