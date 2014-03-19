require "bundler/gem_tasks"
require 'colorize'

namespace :protractor do
  task :install => [:install_nodejs, :install_protractor, :install_webdriver] do

  end

  task :install_nodejs do
    puts "Installing NodeJS...".green
    puts `sudo apt-get -y install nodejs`
  end

  task :install_protractor do
    puts "Installing Protractor".green
    puts `sudo npm install -g protractor`
  end

  task :install_webdriver do
    puts "Installing webdriver using protractor install manager...".green
    system "sudo webdriver-manager update"
  end
end
