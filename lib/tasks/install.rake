require 'colorize'

namespace :protractor do
  desc "Install dependencies for running protractor on your machine"
  task :install => [:install_nodejs, :install_protractor, :install_webdriver] do
  end

  task :install_nodejs do
    if linux?
      puts "Installing NodeJS via apt-get...".green
      system "sudo apt-get -y install nodejs"
    elsif mac?
      puts "Installing NodeJS via homebrew...[THIS IS NOT TESTED YET I DON'T HAVE A MAC]".green
      system "brew install nodejs"
    elsif windows?
      puts "Thank you for choosing to use protractor-rails. Unfortunately Windows is not yet supported. Feel free to contribute.".red
    end
  end

  task :install_protractor do
    puts "Installing Protractor using npm installer".green
    system "sudo npm install -g protractor"
  end

  task :install_webdriver do
    puts "Installing webdriver using protractor install manager...".green
    system "sudo webdriver-manager update"
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
