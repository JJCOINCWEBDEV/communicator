module Communicator
  class Message
    attr_accessor :channel, :params

    def initialize(channel, params)
      @channel = channel
      @params = params.symbolize_keys
    end

    def to_retranslate
      params
    end

    def receive
    end
  end
end
