module Communicator
  class Configuration
    attr_accessor :server, :role, :secret_key, :ssl, :domain, :project, :events, :listeners

    def initialize(options = {})
      options.merge!(configure_with_yaml)
      options.each {|k,v| self.public_send("#{k}=", v) if self.respond_to?("#{k}=") }
    end

    private

    def configure_with_yaml
      begin
        config = YAML.load_file(File.join(Rails.root, "config/communications.yml"))
      rescue Errno::ENOENT
        Rails.logger.error("YAML configuration file couldn't be found. Using defaults."); return
      rescue Psych::SyntaxError
        Rails.logger.error("YAML configuration file contains invalid syntax. Using defaults."); return
      end
      config
    end
  end
end
