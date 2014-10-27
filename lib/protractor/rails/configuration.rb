
require 'yaml'

module Protractor
  class << self
    attr_accessor :configuration
  end

  def self.load file_name
    file_name = file_name

    if File.exists? file_name
      file = File.read file_name
      yaml = ERB.new( file ).result
      data = YAML.load yaml
    end

    return Configuration.new data
  end

  def self.configuration
    @configuration ||= load 'config/protractor.yml'
  end

  class Configuration
    attr_accessor :config_path,
                  :startup_timeout,
                  :port

    def initialize ( data=nil )
      @data = data
      @config_path     = get( :config_path ) || 'spec/javascripts/protractor.conf.js'
      @startup_timeout = get( :startup_timeout ) || 6
      @port            = get( :port ) || 4000
    end

    def get *keys
      keys.inject( @data ) { |result, key| result.try :[], key.to_s }
    end
  end
end
