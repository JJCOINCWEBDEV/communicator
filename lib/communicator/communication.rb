module Communicator
  class Communication
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def register
      # TODO
    end

    def subscribe
      # TODO
    end

    def receive
      subscribers.each do |subscriber|
        submit_event(subscriber.url)
      end if subscribers
    end

    private

    def subscribers
      # TODO
    end

    def submit_event(url)
      Communicator::Request.new.send(url, params.slice(:event, :id, :data, :project))
    end
  end
end
