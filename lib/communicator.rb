require 'communicator/configuration'
require "communicator/engine"
require 'communicator/request'
require 'communicator/communication'
require 'yaml'

module Communicator
  class << self

    def emit_event(event, data, id, model = nil)
      request.post(:listen, event: event, id: id, data: data.to_json, model: model)
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
      register_events configuration.events
      bind_listeners configuration.listeners
      true
    end

    def mount_routes
      Rails.application.routes.prepend do
        mount Communicator::Engine, :at => '/communications'
      end
    end

    def register_events(events)
      events.each do |event, dsl|
        request.post(:register, event: event, dsl: dsl.to_json)
      end if events
    end

    def bind_listeners(listeners)
      listeners.keys.each do |event|
        request.post(:subscribe, event: event, url: "http://#{configuration.domain}/communications/listen/#{event}")
      end if listeners
    end

  end
end
