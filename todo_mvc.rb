require 'bundler'
Bundler.require
require 'tilt/erb'

Opal.append_path File.expand_path('../assets/js', __FILE__)

class TodoMVC < Roda
  plugin :render
  plugin :assets,
    js: 'application.rb', js_opts: { builder: Opal::Builder.new },
    css: 'style.css'
  compile_assets if ENV['COMPILE_ASSETS']

  route do |r|
    r.assets

    render 'index'
  end
end
