module Communicator
  class Message
    attr_reader :channel, :params

    def self.on_retranslate(message)
      message
    end

    def receive(channel, params)
      @channel = channel
      @params = params
    end
  end
end
