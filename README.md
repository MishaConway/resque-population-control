# Resque Population Control!

Resque jobs getting out of hand? Bring them to order with this new resque plugin!

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-population-control'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-population-control

## Usage

The following examples limits Job to having at most 100 enqeueud or running instances.

    class Job
        extend Resque::Plugins::PopulationControl
        population_control 100

         @queue = :jobs

        def self.perform(customer_id)
           ...
        end
    end

By default, a Resque::Plugins::PopulationControl::PopulationExceeded exception will be thrown whenever things get out of hand.
If you wish to suppress this, there is an option to do that. This will cause things to fail silently and prevent any job from getting enqueued if the current population is past the limit.
To get more info and visibility in these situations, you can implement on_population_exceeded to add things like logging and whatever else you deem needed.

    class Job
        extend Resque::Plugins::PopulationControl
        population_control 100, :suppress_exceptions => true

         @queue = :jobs

        def self.perform(customer_id)
           ...
        end

        def self.on_population_exceeded max_size, *args
           logger.debug "Attempt to enqueue #{name} with payload #{args.inspect} failed since population exceeds #{max_size}."
        end
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MishaConway/resque-population-control

