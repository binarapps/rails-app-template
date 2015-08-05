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

after_bundle do
  generate 'rspec:install'
  say('Removing test folder...')
  run 'rm -r test'
  say('Running cap install...')
  run 'bundle exec cap install'

  say('Updating spec_helper...')
  insert_into_file 'spec/spec_helper.rb', before: 'RSpec.configure do |config|' do
<<-CODE
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter 'spec/'
  add_filter 'config/'
  add_group 'Library', '/lib'

  Dir['app/*'].each do |path|
    name = path.split('/').last.capitalize
    add_group name, path unless %w(assets).include?(name)
  end

  add_group 'Long files' do |src_file|
    src_file.lines.count > 100
  end
end

CODE
  end

  say('Setting up hosts for ActionMailer')
  environment "config.action_mailer.default_url_options = { host: 'http://www.example.com' }", env: 'test'
  environment "config.action_mailer.default_url_options = { host: 'http://localhost:3000' }", env: 'development'

  if yes?('Do you want to set the default host for production ActionMailer URL now?')
    url = ask('What is the host address?')
    url = 'http://' << url unless url.match(%r(http(s?)://))
    environment "config.action_mailer.default_url_options = { host: '#{url}' }", env: 'production'
  end

  say('Setting up default ActionMailer config for development environment...')
  environment(nil, env: 'development') do
    "config.action_mailer.smtp_settings = {
      address: 'typex.kylos.pl',
      port: 587,
      authentication: 'plain',
      enable_starttls_auto: true
    }"
  end
end




