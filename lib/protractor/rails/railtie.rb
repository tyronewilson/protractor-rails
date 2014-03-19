module Protractor
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load File.expand_path('../../../tasks/install.rake', __FILE__)
        load File.expand_path('../../../tasks/protractor.rake', __FILE__)
      end
    end
  end
end
