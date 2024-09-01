require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

include Capybara::DSL
Capybara.app_host = "http://#{ENV['WEBSITE_URL']}" # Using Selenium; connect over network
Capybara.run_server = false # Disable Rack since we are using Selenium.
Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Options.chrome(
    args: [
      '--no-default-browser-check',
      '--disable-dev-shm-usage',
      '--headless',
  ]
  )
  Capybara::Selenium::Driver.new(
    app, 
    browser: :remote, 
    url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub", 
    options: options)
end
Capybara.default_driver = :selenium

describe "Example page render unit tests" do
  it "Shows the Explore California logo" do
    visit('/')
    expect(page.has_selector? '.logo').to be true
  end
end
