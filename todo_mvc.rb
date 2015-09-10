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
