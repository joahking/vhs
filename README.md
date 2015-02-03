# VHS

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vhs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vhs

## Usage

Configure your specs adding the @spec/support/vhs.rb@ file provided (TODO provide it).

Then run your spec suite, after that all the cassettes used by your specs are
saved under the directory `spec/fixtures/vcr`.

If you check one of the cassetttes you'll notice the uri has a fixed value (i.e.
your test sandbox's rest url). For the cassettes to be ready for anyone running
the tests they need to be dynamized, i.e. to replace that fixed sandbox rest url
with the value in @AppConfig.sandbox.rest_url@ as specified in
@spec/support/vhs.rb@, you can dymanize your cassettes running:

```bash
ruby -Ilib ./vendor/gems/vhs/bin/vhs-dynamize-cassettes.rb
```

After that add the cassettes to your git repo and enjoy your fast test suite.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vhs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
