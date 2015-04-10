# Tattle

Tattle aims to be a static code analyzer for Ruby. Use it to inspect your code and find bugs that you may have overlooked.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tattle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tattle

## Usage

Using Tattle is as simple as:

    $ tattle my_file.rb

## State of the Project

This project is still in its very early stages. It currently only handles straight-line code,
conditionals and module, class and method definitions. I am working to add more functionality as quickly as possible.
If you encounter a bug with tattle, first consult [this file](KNOW_ISSUES). If it's in there, I am aware of it and I'm
working on it (probably right now). If it's not there, check the open issues on the repo, and create a new one if no
issue exists for your bug.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. 

## Contributing

1. Fork it ( https://github.com/ajm188/tattle/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
