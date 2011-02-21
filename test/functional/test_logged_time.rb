require 'test_helper'
require 'stringio'

class Parakeet
  include MongoMapper::Document
  key :name
end

PARAKEET_NAMES = %w{
  Bro
  Sis
  Larry
  Silvester
  Monterray
}

def make_some_parakeets
  PARAKEET_NAMES.each do |name|
    Parakeet.create!(:name => name)
  end
end

class TestLoggedTime < Test::Unit::TestCase
  context "" do
    setup do
      @str_io = StringIO.new
      @logger = Logger.new(@str_io)
      MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :logger => @logger)
      make_some_parakeets
    end
  
    teardown do
      Parakeet.collection.drop
    end
  
    context "timed logging turned on" do
      setup do
        MongoMapper.logged_time_level = Logger::DEBUG
      end
    
      should "log calls to #all" do
        Parakeet.all
        @str_io.string.should =~ /all query/
        @str_io.string.should =~ /all load/
      end
      
      should "not break all" do
        Parakeet.all.size.should == 5
      end

      should "log time and database and collection and query" do
        Parakeet.where(:name => "Bro").all
        @str_io.string.should =~ /\(\d+.\dms\) all query #{MongoMapper.database.name}\.parakeets \{:name=>"Bro"\}/
        @str_io.string.should =~ /\(\d+.\dms\) all load  #{MongoMapper.database.name}\.parakeets \{:name=>"Bro"\}/
      end

      should "log calls to #first" do
        Parakeet.first
        @str_io.string.should =~ /first query/
        @str_io.string.should =~ /first load/
      end
      
      should "not break first" do
        Parakeet.first.class.should == Parakeet
      end
      
      should "log calls to #last" do
        Parakeet.last
        @str_io.string.should =~ /last query/
        @str_io.string.should =~ /last load/
      end
      
      should "not break last" do
        Parakeet.last.class.should == Parakeet
      end
    end
    
    context "different logger levels" do
      should "not log if logger is set to be less verbose" do
        MongoMapper.logged_time_level = Logger::DEBUG
        @logger.level = Logger::ERROR
        Parakeet.where(:name => "Bro").all
        @str_io.string.should_not =~ /all query|all load/
      end
      
      should "log if logger is set to the same verbosity" do
        MongoMapper.logged_time_level = Logger::INFO
        @logger.level = Logger::INFO
        Parakeet.where(:name => "Bro").all        
        @str_io.string.should =~ /all query.+all load/m
      end
      
      should "log if logger is set to a higher verbosity" do
        MongoMapper.logged_time_level = Logger::WARN
        @logger.level = Logger::INFO
        Parakeet.where(:name => "Bro").all        
        @str_io.string.should =~ /all query.+all load/m
      end
    end
  
    context "timed logging not turned on" do
      # # not sure how to test this...
      # should "default to off" do
      #   Parakeet.all
      #   @str_io.string.should_not =~ /all query|all load/
      # end

      should "allow explicit turning off" do
        MongoMapper.logged_time_level = Logger::DEBUG
        Parakeet.where(:name => "Bro").all
        @str_io.string.should =~ /all query.+all load/m
        
        @str_io.string = ""
        MongoMapper.logged_time_level = nil
        Parakeet.where(:name => "Bro").all
        @str_io.string.should_not =~ /all query|all load/
      end
    end
  end
end