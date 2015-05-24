require 'bundler'
Bundler.require

use Rack::Deflater

require 'opal'
require 'sinatra'

opal = Opal::Server.new {|s|
  s.append_path 'app'
  s.main = 'application'
}

map '/assets' do
  run opal.sprockets
end

get '/style.css' do
  content_type 'text/css'
  File.read('style.css')
end

get '/*' do
  File.read('index.html')
end

run Sinatra::Application
