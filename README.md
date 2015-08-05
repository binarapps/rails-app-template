# Binar::Apps Rails App Template

## Usage

Download the file and run

```
  rails new my_app -m /path/to/file/binarapps_template.rb
```

## Features

* Installs the gems that can be seen in the list below,
* sets up `rspec` and `capistrano`,
* sets up `simplecov` config,
* adds some ActionMailer config - host addresses for all environments (production is optional - if yes, asks for address). _Important notice_ - you'll have to provide username and password for the email account. 

### Featured Gems

``` ruby
  gem_group :test do
    gem 'simplecov', require: false
    gem 'simplecov-rcov'
    gem 'rspec-rails'
    gem 'database_cleaner'
    gem 'faker'
    gem 'capybara'
    gem 'factory_girl_rails'
  end

  gem_group :development do
    gem 'better_errors'
    gem 'binding_of_caller', platforms: [:mri]
    gem 'pry-rails'
    gem 'pry-rescue'
    gem 'thin'
    gem 'capistrano',         '~> 3.2.0'
    gem 'capistrano-rails',   '~> 1.1'
    gem 'capistrano-bundler', '~> 1.1.3'
    gem 'capistrano-rvm'
  end

  gem_group :production do
    gem 'unicorn'
  end
```
