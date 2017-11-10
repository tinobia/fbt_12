source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "bcrypt",                   "~> 3.1.11"
gem "bootstrap",                "~> 4.0.0.beta2.1"
gem "ckeditor",                 "~> 4.2.4"
gem "coffee-rails",             "~> 4.2"
gem "config",                   "~> 1.5.1"
gem "font-awesome-rails",       "~> 4.7.0.2"
gem "image-picker-rails",       "~> 0.2.4"
gem "jbuilder",                 "~> 2.5"
gem "jquery-rails",             "~> 4.3.1"
gem "jquery-ui-rails",          "~> 6.0.1"
gem "mysql2",                   ">= 0.3.18", "< 0.5"
gem "paperclip",                "~> 5.0.0"
gem "puma",                     "~> 3.7"
gem "rails",                    "~> 5.1.4"
gem "rails-controller-testing", "~> 1.0.2"
gem "sass-rails",               "~> 5.0"
gem "turbolinks",               "~> 5"
gem "uglifier",                 ">= 1.3.0"
gem "will_paginate",            "~> 3.1.0"

group :development, :test do
  gem "byebug", platforms: %i(mri mingw x64_mingw)
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
