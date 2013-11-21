require "net/http"
require "uri"

module Communicator
  class Request

    attr_reader :config, :response

    def initialize
      @config = Communicator.configuration
    end

    def post(method, options)
      @response = request(['http://' + config.server, 'communications', method].join('/'), options.merge(project: config.project))
    end

    def send(url, options)
      @response = request(url, options)
    end

    private

    def request(url, params, options = {})
      url = URI.parse(url)
      params = params.merge!({access_key: config.secret_key})
      request = Net::HTTP::Post.new(url.path)
      request.set_form_data(params)

      socket = Net::HTTP.new(url.host, url.port)
      if config.ssl
        socket.use_ssl = true
        socket.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      begin
        response = Rails.env.in?(['development-', 'test']) ? nil : socket.start {|http| http.request(request)}
      rescue Errno::ECONNREFUSED
        response = nil
      end

      parse_response(response)
    end

    def parse_response(response)
      case response
      when Net::HTTPSuccess
        response.body
      else
        {error: response.try(:body) }
      end
    end
  end
end
