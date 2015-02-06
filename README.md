# VHS

VHS stubs all the API calls your test suite does without you
needing to change anything.

VHS makes an intelligent handling of
[VCR](https://source.xing.com/joaquin-rivera/vcr) cassettes to
allow it to stub every API call that your test suite does. It
does so by hooking into Typhoeus and determining the correct
cassette for the request.

On a first run if your API call has no cassette saved the real
call is made, after that the real call will not be executed and
the cassette will be used instead.

That means: faster and more reliable tests without worrying for
stubbing what is not the scope of your spec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vhs', git: 'git@source.xing.com:joaquin-rivera/vhs.git'
gem 'vcr', git: 'git@source.xing.com:joaquin-rivera/vcr.git', branch: 'vhs'
```

And then execute:

    $ bundle

Then configure rspec to use VHS as:

    $ vhs-config-rspec.rb

Now you are ready to run your specs using VHS.

## Usage

After you run your spec suite, all the cassettes used by your
specs are saved under the directory `spec/fixtures/vcr`.

If you check one of the cassetttes you'll notice the uri has a fixed value (i.e.
your test sandbox's rest url). For the cassettes to be ready for anyone running
the specs they need to be dynamized, i.e. to replace that fixed sandbox rest url
with the value in `AppConfig.sandbox.rest_url` as specified in
`spec/support/vhs.rb`, you can dymanize your cassettes running:

    $ vhs-dynamize-cassettes.rb

After that add the cassettes to your git repo and enjoy your fast test suite.

### Turning VHS off

If you have already stubbed calls to `RESTApi` in your spec, you
can turn VHS off using the provided rspec tag:

```ruby
# some spec file
describe XYZ, vhs: false do

context 'a spec context', vhs: false do

it 'is an spec example', vhs: false do
```

or just on the exact place you need to:

```ruby
# some spec file
it 'is an spec stubbing RESTApi call' do
  # code goes here
  VHS.turn_off
  # stub as needed
  RESTApi.stub(:get, %r{/rest/users/users/})
  VHS.turn_on
  # from here on VHS takes over again
end
```

## TODO
- Provide a wiki pages with specs
- Try in in jenkins
- Use it with test unit
- Push the gem to gems.xing.com
- write tests
- clean up code here and in VCR

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vhs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

