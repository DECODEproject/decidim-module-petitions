# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", git: "https://github.com/decidim/decidim", branch: "0.18-stable"
gem "decidim-petitions", path: "."

gem "puma", "~> 3.0"
gem "uglifier", "~> 4.1"

gem "sprockets", "~> 3.7.2"

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri
  gem "sinatra", "~> 2.0"

  gem "decidim-dev"
end

group :development do
  gem "bootsnap"
  gem "faker", "~> 1.9"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
