require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.



  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'

  FakeWeb.allow_net_connect = false

  #################################
  # For JS tests
  #
  #require 'capybara/poltergeist'
  #Capybara.javascript_driver = :poltergeist
  #
  #################################

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|

    config.mock_with :rspec

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # false and DatabaseCleaner from http://railscasts.com/episodes/257-request-specs-and-capybara
    config.use_transactional_fixtures = false

    #config.before(:suite) do
    #  DatabaseCleaner.strategy = :truncation
    #  DatabaseCleaner.clean
    #end

    config.before(:each) do
      FakeWeb.clean_registry
      DatabaseCleaner.strategy = if example.metadata[:js]
                                   :truncation
                                 else
                                   :transaction
                                 end
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end


    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # http://railscasts.com/episodes/285-spork
    #config.treat_symbols_as_metadata_keys_with_true_values = true
    #config.filter_run :focus => true
    #config.run_all_when_everything_filtered = true

    # Devise
    #config.include Devise::TestHelpers, :type => :controller

    # Factory Girl from http://railscasts.com/episodes/158-factories-not-fixtures-revised
    config.include FactoryGirl::Syntax::Methods

    # CanCan from https://github.com/ryanb/cancan/wiki/Testing-Abilities
    #config.require "cancan/matchers"


  end


end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.

