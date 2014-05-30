source 'https://rubygems.org'
ruby '2.0.0'

gem "rake"
gem "sinatra"
gem "sinatra-activerecord"
gem "activerecord", "3.2.17"
gem "minty", :git => 'https://github.com/demsullivan/minty.git'
gem "foreman"

gem "haml"
gem "sass"
gem "coffee-script"

group :development, :test do
  gem 'rspec'
  gem 'pry'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

gem 'thin'
