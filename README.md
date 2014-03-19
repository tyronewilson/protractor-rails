# Protractor::Rails

This gem helps you to not go through the same pain that I did trying to figure out the best way to run angularjs e2e tests in a rails application.

NB: This gem is in pre-release so don't use it yet.

## Installation

Add this line to your application's Gemfile:

    gem 'protractor-rails'

And then execute the following command to load dependencies on your machine:

    $ rake protractor:install

You can test that everything has been set up correctly using the command below.
This command will run protractor's example configuration and test file against the
http://angular.org website. If everything starts up ok and runs till the end giving you
a summary of test results then you are 'good to go'!

    $ rake protractor:example

NB: This uses `sudo` so you will need to enter your password

## Usage



## Contributing

1. Fork it ( http://github.com/<my-github-username>/protractor-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
