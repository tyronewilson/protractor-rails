require 'optparse'

namespace :protractor do |args|
  desc "starts protractor example test to see if you have your system set up correctly"
  task :example do
    begin
      webdriver_pid = fork do
        Rake::Task["protractor:webdriver"].invoke
      end
      write_log "Waiting for test server and webdriver server to start"
      sleep 5
      file = File.expand_path('../../../spec/protractor_example.conf.js', __FILE__)
      system "protractor #{file}"
    ensure
      Rake::Task["protractor:kill_webdriver"].invoke
      Rake::Task["protractor:kill_selenium_processes"].invoke
    end
  end

  def write_log(message)
    return if ENV['nolog'].present?
    puts message
  end

  desc "Run specs from config file"
  task :spec do
    begin
      options = ''
      OptionParser.new(args) do |opts|
        # Test specific spec files instead of a whole suite.
        specsKey = '--specs'
        opts.on("#{specsKey} {filename}", 'Test spec files', String) do |filename|
          options = options + "#{specsKey} #{filename}"
        end
        # Suite setup
        suiteKey = '--suite'
        opts.on("#{suiteKey} {suite}", 'Test suite name', String) do |suite|
          options = options + "#{suiteKey} #{suite}"
        end
      end.parse!

      webdriver_pid = fork do
        [$stdout,$stderr].each { |fh| fh.reopen File.open("/dev/null","w") } if ENV['nolog'].present? || ENV['nolog_selenium'].present?
        Rake::Task['protractor:webdriver'].invoke
      end
      rails_server_pid = fork do
        [$stdout,$stderr].each { |fh| fh.reopen File.open("/dev/null","w") } if ENV['nolog'].present? || ENV['nolog_rails'].present?
        Rake::Task['protractor:rails'].invoke
      end
      write_log "webdriver PID: #{webdriver_pid}"
      write_log "Rails Server PID: #{rails_server_pid}".yellow.bold
      write_log "Waiting for servers to finish starting up...."
      sleep Protractor.configuration.startup_timeout
      success = system "protractor #{options} #{Protractor.configuration.config_path}/#{Protractor.configuration.config_file}"
      write_log "Protractor has failed to run test with options '#{options}'".red.bold unless success
      Process.kill 'TERM', webdriver_pid
      Process.kill 'TERM', rails_server_pid
      Process.wait webdriver_pid
      Process.wait rails_server_pid
      write_log "Waiting to shut down cleanly.........".yellow.bold
      sleep 5
    rescue Exception => e
      puts e
    ensure
      Rake::Task["protractor:kill"].invoke
      exit unless success
    end
  end

  task :spec_and_cleanup => [:spec, :cleanup]

  task :kill do
    write_log "killing running protractor processes".green.bold
    Rake::Task["protractor:kill_rails"].invoke
    Rake::Task["protractor:kill_webdriver"].invoke
    Rake::Task["protractor:kill_selenium_processes"].invoke
  end

  task :kill_selenium_processes do
    write_log "kill left over selenium processes...".yellow
    system "ps aux | grep -ie 'protractor\/selenium' | grep -v grep | awk '{print $2}' | xargs kill -9"
  end

  task :kill_webdriver do
    write_log "kill webdriver server...".yellow
    system "ps aux | grep -ie '\-Dwebdriver' | grep -v grep | awk '{print $2}' | xargs kill -9"
  end

  task :kill_rails do
    write_log "kill protractor rails tests server...".yellow
    system "ps aux | grep -ie 'rails s -e test -P tmp/pids/protractor_test_server.pid --port=#{Protractor.configuration.port}' | grep -v grep | awk '{print $2}' | xargs kill -9"
  end

  task :rails do
    write_log "Starting Rails server on port #{Protractor.configuration.port} pid file in tmp/pids/protractor_test_server.pid".green
    rails_command = "rails s -e test -P tmp/pids/protractor_test_server.pid --port=#{Protractor.configuration.port}"
    if ENV['rails_binding'] != nil
      rails_command << " --binding #{ ENV['rails_binding'] }"
    end
    system rails_command
  end

  task :webdriver do
    write_log "Starting selenium server".green
    system "webdriver-manager start"
  end

  task :cleanup do
    write_log "rake db:test:prepare to cleanup for the next test session".green
    system 'rake db:test:prepare --trace'
    write_log "Seeding the test database....".green
    system "rake db:test:seed --trace"
  end
end

namespace :db do
  namespace :test do
    desc "seed only the test database (Task provided by protractor-rails)"
    task :seed do
      system "rake db:seed RAILS_ENV=test"
    end
  end
end
