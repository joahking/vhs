# VHS

VHS stubs all the API calls performed in your test suite, without you needing
to change your tests.

VHS makes an intelligent handling of
[VCR](https://source.xing.com/joaquin-rivera/vcr) cassettes to
stub every API call that your test suite does. It
does so by hooking into Typhoeus and determining the correct
cassette for the request being performed.

On a first run if your API call has no cassette saved the real
call is made. After that the real call will not be executed and
the cassette will be used instead.

That means: faster and more reliable tests without worrying for
stubbing what is not the scope of your test.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vhs', '~> 0.1.0'
```

And then execute:

    $ bundle

Then configure VHS and rspec to use VHS as:

    $ vhs config cli
    $ vhs config rspec

The first command copies a `.vhs.yml` file to your root with configuration
options for VHS, check it out to see the options. The second command configures
RSpec to use VHS.

Now you are ready to run your specs using VHS.

## Usage

After you run your spec suite, the cassettes used by your specs are saved under
the directory `spec/fixtures/vhs`.

To know whether all of the API calls succeeded you can list the error ones using:

    $ vhs list error

And update them accordingly

    $ vhs update error

Check the help of both commands to know the posibilities at your disposal.

## Fixing specs suite

TimeBandits break the usage of VHS, to make it work, you need to remove lines like

```ruby
    RESTApi.run_with_time_bandit(TimeBandits::CustomConsumers::Search)
```

TODO add details here and in wiki pages about conflicts and ways of fixing them

## Turning VHS off

If you have already stubbed calls to `RESTApi` in your spec, you
can turn VHS off using the provided rspec tag at `describe`, `context`, or `it`
level:

```ruby
# some spec file
describe XYZ, vhs: false do

context 'a spec context', vhs: false do

it 'is an spec example', vhs: false do
```

or leave VHS running for part of your spec, and just turn it off on the exact
place you need to:

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

## Add cassettes to git

It makes sense to add the cassettes to your repo once the test suite is green.

But before you do so, check that your cassetttes have a fixed url value (i.e.
your test sandbox's rest url).
To ready them for anyone running the specs the cassettes need to be dynamized,
i.e. to replace that fixed sandbox rest url with the value in
`AppConfig.sandbox.rest_url`.

You can dymanize your cassettes running:

    $ vhs dynamize

After that add the cassettes to your git repo and your team can enjoy your fast
test suite.

## TODO
- Provide a wiki pages with specs
- Try in in jenkins
- Use it with test unit
- write tests
- clean up code here and in VCR

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vhs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

