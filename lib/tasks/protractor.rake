namespace :protractor do
  desc "starts protractor example test to see if you have your system set up correctly"
  task :example do

  end

  task :suite do
    begin
      rails_pid
    end
  end

  task :kill do
    puts "killing running protractor processes".green.bold
    puts "kill protractor rails tests server...".yellow
    system "ps aux | grep -ie 'rails s -e test --port=4000 -P tmp/pids/protractor_test_server.pid' | awk '{print $2}' | xargs kill -9"
    puts "kill webdriver server...".yellow
    system "ps aux | grep -ie '\-Dwebdriver' | awk '{print $2}' | xargs kill -9"
    puts "kill left over selenium processes...".yellow
    system "ps aux | grep -ie 'protractor\/selenium' | awk '{print $2}' | xargs kill -9"
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
