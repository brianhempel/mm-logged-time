module MmLoggedTime
  module DecoratorExtensions
    # if someone can figure out a cleaner way to do this, please let me know
    # can't just 'include' because then super also tries to load the doc
    # undef also handly breaks everything
    # overriden code here: https://github.com/jnunemaker/mongomapper/blob/master/lib/mongo_mapper/plugins/querying/decorator.rb
    INSTANCE_METHODS = <<-BIG_EVAL
      def all(opts={})
        result = nil
        log_time("all query") { result = super }
        log_time("all load ") { result.map { |doc| model.load(doc) } }
      end

      def first(opts={})
        result = nil
        log_time("first query") { result = super }
        log_time("first load ") { model.load(result) }
      end

      def last(opts={})
        result = nil
        log_time("last query") { result = super }
        log_time("last load ") { model.load(result) }
      end
    
      private
        def log_time(msg)
          logger = model.logger
          result = nil
          if logger && MongoMapper.logged_time_level && logger.level <= MongoMapper.logged_time_level
            time = Benchmark.realtime do
              result = yield
            end
            time_ms = (time*10000).round / 10.0
            logger.add MongoMapper.logged_time_level, "(\#{time_ms}ms) \#{msg} \#{collection.db.name}.\#{collection.name} \#{to_hash.inspect}"
            result
          else
            yield
          end
        end
    BIG_EVAL
  end
end