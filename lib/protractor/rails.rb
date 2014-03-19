require "protractor/rails/version"
require 'protractor/rails/railtie'

module Protractor
  module Rails
    class PlatformHelper
      def self.mac?
        RbConfig::CONFIG['target_os'] =~ /darwin/i
      end

      def self.linux?
        RbConfig::CONFIG['target_os'] =~ /linux/i
      end

      def self.windows?
        RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
      end
    end
  end
end
