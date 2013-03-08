source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'thin'

# Persistance
gem 'pg'
gem 'activerecord-postgres-hstore'

# Views
gem 'haml'
gem 'jquery-rails'

# Models
gem 'state_machine'
gem 'awesome_nested_set'
gem 'unread'
gem 'kaminari' # Paginate
gem 'sorcery'  # Authentication
gem 'webster'  # Random Dictionary Word
gem 'paranoia'

# Permissions
gem 'cancan'

# Image Uploader
gem 'mini_magick'
gem 'fog'
gem 'carrierwave'

# Utils
gem 'embedly'
gem 'mini_fb'
gem 'delayed_job_active_record'
gem 'feedzirra', :git => 'git://github.com/jnoh/feedzirra.git'
gem 'nokogiri'

# Admin
gem 'activeadmin'
gem 'intercom-rails', '~> 0.2.11'
gem 'readable_random'

# Exception Tracker
gem 'honeybadger'

group :development do
  gem 'sqlite3'
  gem 'mailcatcher'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'handlebars_assets'
end

group :test, :development do
  gem 'rspec'
  gem "rspec-rails", "~> 2.0"
  # Pretty printed test output
  gem 'turn', :require => false
end
