require 'communicator/configuration'
require "communicator/engine"
require 'communicator/pub_sub'
require 'communicator/message'
require 'communicator/request'
require 'communicator/communication'
require 'yaml'

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

    def get_status(event, id, model = nil)
      request.post(:fetch, event: event, id: id, model: model)
    end

    def configure
      yield(configuration) if block_given?
      init_communications
    end

    def configuration
      @configuration ||=  Communicator::Configuration.new
    end

    private

    def request
      @request ||=  Communicator::Request.new
    end

    def init_communications
      mount_routes
      true
    end

    def mount_routes
      Rails.application.routes.prepend do
        mount Communicator::Engine, :at => '/communications'
      end
    end
  end
end
