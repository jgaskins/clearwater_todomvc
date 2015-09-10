require 'bundler'
Bundler.require

Opal.append_path File.expand_path('../assets/js', __FILE__)
require './todo_mvc'

use Rack::Deflater


run TodoMVC
