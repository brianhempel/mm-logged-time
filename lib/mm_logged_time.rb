require 'logger'
require 'mongo_mapper'

module MmLoggedTime
  VALID_LEVELS = [
    nil,
    Logger::FATAL,
    Logger::ERROR,
    Logger::WARN,
    Logger::INFO,
    Logger::DEBUG
  ]
end

require 'mm_logged_time/mongo_mapper_extensions.rb'
require 'mm_logged_time/decorator_extensions.rb'

MongoMapper.extend(MmLoggedTime::MongoMapperExtensions::ClassMethods)
MongoMapper::Plugins::Querying::Decorator.module_eval(MmLoggedTime::DecoratorExtensions::INSTANCE_METHODS)