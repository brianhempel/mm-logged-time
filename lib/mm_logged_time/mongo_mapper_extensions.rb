module MmLoggedTime
  module MongoMapperExtensions
    module ClassMethods
      def logged_time_level=(level)
        unless MmLoggedTime::VALID_LEVELS.include?(level)
          raise "Invalid log level.  Valid options are: #{MmLoggedTime::VALID_LEVELS.inspect}"
        end
        @logged_time_level = level
      end
      
      def logged_time_level
        @logged_time_level
      end
    end
  end
end