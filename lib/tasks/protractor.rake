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
    system 'rails s -e test --port=4000 -P tmp/pids/protractor_test_server.pid'
  end

  task :webdriver do
    puts "Starting selenium server".green
    system "webdriver-manager start"
  end

  task :cleanup do
    puts "rake db:test:prepare to cleanup for the next test session".green.bold
    system 'rake db:test:prepare --trace'
  end
end
