namespace :protractor do
  desc "starts protractor example test to see if you have your system set up correctly"
  task :example do
    begin
      webdriver_pid = fork do
        Rake::Task["protractor:webdriver"].invoke
      end
      puts "Waiting for test server and webdriver server to start"
      sleep 5
      file = File.expand_path('../../../spec/protractor_example.conf.js', __FILE__)
      system "protractor #{file}"
    ensure
      Rake::Task["protractor:kill_webdriver"].invoke
      Rake::Task["protractor:kill_selenium_processes"].invoke
    end
  end

  desc "Run specs from spec/javascripts/protractor.conf.js"
  task :spec do
    begin
      webdriver_pid = fork do
        Rake::Task['protractor:webdriver'].invoke
      end
      rails_server_pid = fork do
        Rake::Task['protractor:rails'].invoke
      end
      puts "webdriver PID: #{webdriver_pid}".yellow.bold
      puts "Rails Server PID: #{rails_server_pid}".yellow.bold
      puts "Waiting for servers to finish starting up...."
      sleep 6
      system 'protractor spec/javascripts/protractor.conf.js'
      Process.kill 'TERM', webdriver_pid
      Process.kill 'TERM', rails_server_pid
      Process.wait webdriver_pid
      Process.wait rails_server_pid
      puts "Waiting to shut down cleanly.........".yellow.bold
      sleep 5
    rescue Exception => e
      puts e
    ensure
      Rake::Task["protractor:kill"].invoke
    end
  end

  task :spec_and_cleanup => [:spec, :cleanup]

  task :kill do
    puts "killing running protractor processes".green.bold
    Rake::Task["protractor:kill_rails"].invoke
    Rake::Task["protractor:kill_webdriver"].invoke
    Rake::Task["protractor:kill_selenium_processes"].invoke
  end

  task :kill_selenium_processes do
    puts "kill left over selenium processes...".yellow
    system "ps aux | grep -ie 'protractor\/selenium' | awk '{print $2}' | xargs kill -9"
  end

  task :kill_webdriver do
    puts "kill webdriver server...".yellow
    system "ps aux | grep -ie '\-Dwebdriver' | awk '{print $2}' | xargs kill -9"
  end

  task :kill_rails do
    puts "kill protractor rails tests server...".yellow
    system "ps aux | grep -ie 'rails s -e test --port=4000 -P tmp/pids/protractor_test_server.pid' | awk '{print $2}' | xargs kill -9"
  end

  task :rails do
    puts "Starting Rails server on port 4000 pid file in tmp/pids/protractor_test_server.pid".green
    system 'rails s -e test --port=4000 -P tmp/pids/protractor_test_server.pid'
  end

  task :webdriver do
    puts "Starting selenium server".green
    system "webdriver-manager start"
  end

  task :cleanup do
    puts "rake db:test:prepare to cleanup for the next test session".green
    system 'rake db:test:prepare --trace'
    puts "Seeding the test database....".green
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
