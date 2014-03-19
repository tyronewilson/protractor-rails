require "protractor"
require "rails"

module Protractor
  module Rails
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'lib/tasks/installer.rake'
      end
    end
  end
end
