# Same::Interactor

[![Build Status](https://travis-ci.org/samesystem/same-interactor.svg?branch=master)](https://travis-ci.org/samesystem/same-interactor)
[![codecov](https://codecov.io/gh/samesystem/same-interactor/branch/master/graph/badge.svg)](https://codecov.io/gh/samesystem/same-interactor)
[![Documentation](https://readthedocs.org/projects/ansicolortags/badge/?version=latest)](https://samesystem.github.io/same-interactor)

Service / Interactor on steroids.

## Full Documentation

Check https://samesystem.github.io/same-interactor for more details

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'same-interactor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install same-interactor


## Getting started

This Same::Interactor is build on top of [Interactor](https://github.com/collectiveidea/interactor) gem. So everything what works with `Interactor` should work with `Same::Interactor` too. `Same::Interactor` just adds few additional features:
* `context_attr` which allows to define required context attributes or attributes with defaults
* validations which fails interactor before executing `call` method when validations fails. Also it returns validation errors.

## Usage

```ruby
class MyService
  include Same::Interactor

  validates :my_positive_number, numericality: { greater_than: 0 }

  context_attr :my_attr
  context_attr :my_optional_attr, optional: true
  context_attr :my_attr_with_default, default: -> { my_attr }
  context_attr :my_positive_number

  def call
    context.received_my_attr_with_default = my_attr_with_default
  end
end

# validations:
result = MyService.call(my_attr: 'foo', my_positive_number: -1000)
result.success? # => false
result.errors.full_messages # => ["My positive number must be greater than 0"]

# using defaults:
result = MyService.call(my_attr: 'foo', my_positive_number: 1)
result.received_my_attr_with_default # => "foo"
result = MyService.call(my_attr: 'foo', my_positive_number: 1, my_attr_with_default: 'bar')
result.received_my_attr_with_default # => "bar"

# missing required context_attr
MyService.call(my_positive_number: 1) # => raises Same::Interactor::MissingAttributeError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/samesystem/same-interactor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Same::Interactor project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/samesystem/same-interactor/blob/master/CODE_OF_CONDUCT.md).
