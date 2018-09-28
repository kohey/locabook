require 'bundler'
Bundler.require

require './app.rb'
require 'dotenv'

Dotenv.load

RakutenWebService.configure do |c|
  c.application_id = ENV['RAKUTEN_APPLICATION_ID'] 
end

run Sinatra::Application

