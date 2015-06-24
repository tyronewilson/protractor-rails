require 'colorize'

namespace :protractor do
  desc "Install dependencies for running protractor on your machine"
  task :install => [:check_nodejs_installed, :install_protractor, :install_webdriver] do
  end

  task :check_nodejs_installed do
    if linux? || mac?
      puts "Check that Nodejs is installed"
      result = `node -v`
      if result
        puts "Nodejs #{result[0..-2]} found [OK]".yellow
      else
        raise "Nodejs is not installed. Please installed Nodejs and run this script again".red
      end
    elsif windows?
      puts "Thank you for choosing to use protractor-rails. Unfortunately Windows is not yet supported. Feel free to contribute.".red
    end
  end

  task :install_protractor do
    puts "Installing Protractor using npm installer".green
    system "npm install -g protractor"
  end

  task :install_webdriver do
    puts "Installing webdriver using protractor install manager...".green
    system "webdriver-manager update --standalone"
  end

  task :coffee_script_support do
    puts "Installing RequireJS on your machine.....".green
    system "npm install -g requirejs"
    puts "Installing coffee-script with npm".green
    system "npm install -g coffee-script"
    puts "You have dependencies installed and ready to use. Read the coffee-script section at https://github.com/tyronewilson/protractor-rails for details on configuration"
  end

  desc "Initialize protractor rails."
  task :init do
    conf_path = Protractor.configuration.config_path
    conf_file = File.join(conf_path, Protractor.configuration.config_file)
    spec_path = Protractor.configuration.spec_path

    if !File.directory?(spec_path)
      puts "You have chosen to put your protractor-rails specs file in #{spec_path} but the directory doesn't exist. Please create it and then rerun this command".red
      next
    end
    if File.exist? conf_file
      puts "You already have a configuration file. If you would like to start over, remove #{Protractor.configuration.config_path} and run rake protractor:init".red
      next
    else
      puts "Creating template configuration file in #{conf_path}".green
      template_path = File.expand_path("../../../spec/javascripts/templates", __FILE__)
      template_conf = File.join(template_path, 'protractor.conf.js')
      template_spec = File.join(template_path, 'example_spec.js')
      system "cp #{template_conf} #{conf_file}"
      puts "You will need to edit the #{conf_file} file to suite your requirements."
      system "cp #{template_spec} #{File.join(Protractor.configuration.spec_path, 'example_spec.js')}"
      puts "created example_spec.js in #{spec_path}. You can test it out by running rake protractor:example"
    end
  end
end

def mac?
  RbConfig::CONFIG['target_os'] =~ /darwin/i
end

def linux?
  RbConfig::CONFIG['target_os'] =~ /linux/i
end

def windows?
  RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
end
