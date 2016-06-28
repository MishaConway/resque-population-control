module Resque
  module Plugins
    module PopulationControl
      VERSION = "0.1.0"

      class PopulationExceeded < ::StandardError; end;

      def population_control max
        @population_control_max = max
      end

      def before_enqueue *args
        population_control_count = population_control_increment
        if population_control_count > population_control_max
          population_control_decrement
          suppress_exception = respond_to?(:on_population_exceeded) && on_population_exceeded(population_control_max, *args)
          unless suppress_exception
            raise PopulationExceeded, "Enqueuing #{name} would exceed max allowed population of #{population_control_max}."
          end
          false
        end
      end

      def after_perform *args
        population_control_decrement
      end

      def population_control_max
        @population_control_max
      end

      def population_control_increment
         population_control_redis.incr population_control_cache_key
      end

      def population_control_decrement
        population_control_redis.decr population_control_cache_key
      end

      def population_control_redis
        @population_control_redis ||= Resque.redis.redis
      end

      def population_control_cache_key
        "population_control_count_for_#{name}"
      end
    end
  end
end