require 'rubygems'
require 'bundler/setup'

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'matchy'
require 'shoulda'
require 'mongo_mapper'
require 'mm_logged_time'

MongoMapper.database = "mm-test-#{RUBY_VERSION.gsub('.', '-')}"