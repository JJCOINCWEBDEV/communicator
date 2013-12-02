require 'redis'
require 'json'

module Communicator
  class PubSub
    class << self
      def redis
        redis_conf = Communicator.configuration.redis
        redis = Redis.new(redis_conf)
      end

      def publish(channel, message)
        redis.publish(channel, message.to_json)
      end

      def subscribe(channels, &block)
        redis.subscribe(channels) do |on|
          on.message do |channel, msg|
            message = JSON.parse(msg)
            yield channel, message if block_given?
          end
        end
      end
    end
  end
end
