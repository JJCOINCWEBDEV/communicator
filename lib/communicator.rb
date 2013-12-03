require 'communicator/configuration'
require 'communicator/pub_sub'
require 'communicator/message'

module Communicator
  class << self

    def publish(channel, message)
      Communicator::PubSub.publish('common', {channel: channel, message: message})
    end

    def subscribe(channels)
      Communicator::PubSub.subscribe channels do |channel, params|
        Communicator::Message.new(channel, params).receive
      end if channels
    end

    def retranslate
      Communicator::PubSub.subscribe 'common' do |common_channel, attrs|
        channel = attrs.delete(:channel)
        params = attrs.delete(:message)
        message = Communicator::Message.new(channel, params)
        Communicator::PubSub.publish(channel, message.retranslate_params)
        message.receive
      end
    end

    def emit_event(event, data, id, model = nil)
      dsl = configuration.events.try(:[], event.to_s))
      publish(event, {id: id, data: data, model: model, dsl: dsl})
    end

    def configure
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||=  Communicator::Configuration.new
    end
  end
end
