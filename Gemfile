source 'http://rubygems.org'

gem 'rails', '3.2.6'
gem 'thin'

# Persistance
gem 'pg'

# Views
gem 'haml'
gem 'jquery-rails'

# Models
gem 'state_machine'
gem 'awesome_nested_set'
gem 'unread'
gem 'kaminari' # Paginate
gem 'sorcery'  # Authentication

# Image Uploader
gem 'rmagick'
gem 'fog'
gem 'carrierwave'

# Utils
gem 'embedly'
gem 'mini_fb'

# Analytics
gem 'intercom-rails', '~> 0.2.11'

group :production do
  gem 'pg'
end

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

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
