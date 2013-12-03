require 'communicator/configuration'
require 'communicator/pub_sub'
require 'communicator/message'

module Communicator
  class << self

    def publish(options)
      dsl = configuration.events.try(:[], options.try(:[], 'channel'))
      Communicator::PubSub.publish('common', options.merge(dsl: dsl))
    end

    def subscribe(channels)
      Communicator::PubSub.subscribe channels do |channel, message|
        Communicator::Message.new(channel, message).receive
      end if channels
    end

    def retranslate
      Communicator::PubSub.subscribe 'common' do |channel, message|
        channel = message.delete('channel')
        message = Communicator::Message.new(channel, message)
        Communicator::PubSub.publish(channel, message.retranslate_params)
        message.receive
      end
    end

    def emit_event(event, data, id, model = nil)
      publish({channel: event, id: id, data: data, model: model})
    end

    def configure
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||=  Communicator::Configuration.new
    end
  end
end
