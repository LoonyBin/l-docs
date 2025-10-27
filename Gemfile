source "https://rubygems.org"

gem "bootsnap", require: false
gem "haml-rails"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "jbuilder"
gem "kamal", require: false
gem "rails", "~> 8.1.0"
gem "pg", "~> 1.1"
gem "propshaft"
gem "puma", ">= 5.0"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "stimulus-rails"
gem "thruster", require: false
gem "turbo-rails"

gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "faker"
  gem "html2haml"
  gem "pry-rails"
  gem "rspec-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "formulaic"
  gem "rspec-its"
  gem "shoulda-matchers"
end

group :lint do
  gem "haml_lint"
  gem "rubocop"
  group "rubocop" do
    gem "rubocop-i18n"
    gem "rubocop-performance"
    gem "rubocop-rails"
    gem "rubocop-rails-omakase"
    gem "rubocop-rake"
    gem "rubocop-rspec"
  end
end
