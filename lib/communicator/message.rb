module Communicator
  class Message
    attr_accessor :channel, :params

    def initialize(channel, params)
      @channel = channel
      @params = params.symbolize_keys
    end

    def retranslate_params
      on_retranslate || params
    end

    def on_retranslate
      # TODO
    end

    def receive
      # TODO
    end
  end
end
