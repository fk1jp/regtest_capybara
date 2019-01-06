# for capybara
require 'capybara'
require 'selenium-webdriver'
require 'webdriver-user-agent'

# スマホで表示するための設定
#Capybara.register_driver :selenium_sp do |app|
#  Capybara::Selenium::Driver.new(app, :js_errors => true, :timeout => 60, window_size: [320, 580])
#end

Capybara.register_driver :selenium_sp do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_emulation(user_agent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15E148 Safari/604.1')
  options.add_emulation(device_metrics: {width: 375, pixelRatio: 1, touch: true})
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :timeout => 60, :options => options)
end


# PCで表示するための設定
Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_emulation(device_metrics: {width: 1600})
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :timeout => 60, :options => options)
end


Capybara.configure do |config|
  #config.default_driver = :selenium
  config.default_driver = :selenium
  config.run_server = false
  config.app_host = "#{ ARGV[1] || "http://www.meti.go.jp/" }"
end

#Capybara.javascript_driver = :selenium
Capybara.javascript_driver = :selenium
