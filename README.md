# Protractor::Rails

This gem helps you seamlessly setup, run and maintain a angularjs e2e test suite using protractor in a rails application.

## Installation

Add this line to your application's Gemfile:

    gem 'protractor-rails'

And then execute the following command to load dependencies on your machine:

    $ rake protractor:install

    NB: This uses `sudo` so you will need to enter your password


You can test that everything has been set up correctly using the command below.
This command will run protractor's example configuration and test file against the
http://angular.org website. If everything starts up ok and runs till the end giving you
a summary of test results then you are 'good to go'!

    $ rake protractor:example

## Usage

### Initialization

You can initialize your app with protractor rails by running

    $ rake protractor:init

### Dummy test in local environment

This will generate and template configuration and a dummy example test. Once you have run this you can test that
everything has been set up correctly in your local environment by running the following command:

    $ rake protractor:spec

This will run a local rails test server, the webdriver selenium server and run protractor against the example_spec.js
If everything starts up and runs cleanly you should see the test summary of 1 test 1 pass and 0 failures.

### Running your tests

When the `rake protractor:init` script is run it will create a file `spec/javascripts/protractor.conf.js`. This file is where you
can configure the tests that should be run. [See Protractor Documentation for more details]:https://github.com/angular/protractor/blob/master/docs/getting-started.md.

In this file you can provide patterns for matching your protractor specs. **NB: It is recommended that you use a subdirectory such as spec/javascripts/protractor_specs for easy matching and organization**

**Example**

If I have a directory set up for protractor specs in `spec/javascripts/protractor_specs/`, my configuration file would look something like the below

```
  // An example configuration file.
  exports.config = {
    // The address of a running selenium server.
    seleniumAddress: 'http://localhost:4444/wd/hub',

    // Capabilities to be passed to the webdriver instance.
    capabilities: {
        'browserName': 'chrome'
    },

    // Spec patterns are relative to the current working directly when protractor is called
    specs: ['protractor_specs/**/*.js '],

    baseUrl: 'http://localhost:4000',

    // Options to be passed to Jasmine-node.
    jasmineNodeOpts: {
        showColors: true,
        defaultTimeoutInterval: 30000
    },
};

```

Once you have setup your tests as above, running `rake protractor:spec` will pick up new tests and run them for you`

### Setup and teardown

There is a task to reset your database to remove items you have created during your tests. This will also seed your database with any fixtures you might have prepared

    $ rake protractor:cleanup

This will reset your test database and load in seeds in db/seeds.rb into your test database only.

There is also a convenience function for running cleanup after you have run your tests ready for the next test run.

    $ rake protractor:spec_and_cleanup

## Notes about integration tests

Integration tests are **MUCH** faster than testing things yourself but they are MUCH slower than running unit tests or
rspec tests. Keep your integration tests to a minimum and test as much as possible with your normal rails test suite.


## Contributing

**Contributions, questions, comments, threats or suggestions are welcome.**

1. Fork it ( http://github.com/<my-github-username>/protractor-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
