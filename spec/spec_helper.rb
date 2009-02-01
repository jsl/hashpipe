require 'rubygems'
require 'ostruct'
require 'mocha'
require 'spec'
require 'activerecord'

Spec::Runner.configure do |config|
  config.mock_with(:mocha)
end

require File.join(File.dirname(__FILE__), %w[.. init])

RAILS_DEFAULT_LOGGER = Logger.new(STDOUT) unless defined?(RAILS_DEFAULT_LOGGER)
RAILS_ROOT = File.join(File.dirname(__FILE__), '..')  unless defined?(RAILS_ROOT)
RAILS_ENV = 'test' unless defined?(RAILS_ENV)