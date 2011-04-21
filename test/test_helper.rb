ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'logger'

gem 'activerecord',  '~>3.0.0'
gem 'activesupport', '~>3.0.0'
gem 'actionpack',    '~>3.0.0'

require 'active_record'
require 'active_record/version'
require 'active_support'

require 'acts_as_followable'
require File.dirname(__FILE__) + '/../rails/init'
require File.dirname(__FILE__) + '/models/band'
require File.dirname(__FILE__) + '/models/user'
require File.dirname(__FILE__) + '/../app/models/follow.rb'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'mysql')

require 'factory_girl'
Factory.find_definitions

load(File.dirname(__FILE__) + '/schema.rb')
