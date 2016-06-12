# Clearwater TodoMVC

The [TodoMVC](http://todomvc.com) project has examples of various front-end frameworks implementing a to-do list.

This application uses the [Clearwater](https://github.com/clearwater-rb/clearwater) framework.

## Clearwater

Clearwater is a rich front-end framework for building fast, reasonable, and easily composable browser
applications in Ruby.
It renders to a virtual DOM and applies the virtual DOM to the browser's actual
DOM to update only what has changed on the page.

## Running the application

To run the application you need ruby and bundler installed. Any ruby version above 1.9.3 will do.
"gem install bundler"  will install bundler if it is not installed yet.

- Clone the repository
- cd into the directory

`bundle`
`bundle exec rackup`

- go to [localhost:9292](http://localhost:9292)

## Extra

If you want to compile assets, make sure you run `rake assets:precompile` or start the app with `COMPILE_ASSETS=true rackup`.
