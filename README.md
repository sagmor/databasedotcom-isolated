# databasedotcom-isolated

[![Build Status](https://travis-ci.org/sagmor/databasedotcom-isolated.png)](https://travis-ci.org/sagmor/databasedotcom-isolated)
[![Dependency Status](https://gemnasium.com/sagmor/databasedotcom-isolated.png)](https://gemnasium.com/sagmor/databasedotcom-isolated)


This gem let's you perform actions using the databasedotcom gem without having
to worry about constant pollution and modules namespacing.

## Installation

Add this line to your application's Gemfile:

    gem 'databasedotcom-isolated'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install databasedotcom-isolated

## Usage

```ruby
# define your connection options
options = {
  # App credentials
  client_id: 'YOUR_CLIENT_ID',
  client_secret: 'YOUR_CLIENT_SECRET',

  # Oauth token authentication
  token: 'YOUR_AUTHENTICATION_TOKEN',

  # Or alternatively
  username: 'YOUR_USERNAME',
  password: 'YOUR_PASSWORD_AND_SECRET_TOKEN'
}

# Perform everything inside a block
Databasedotcom::Isolated.perform(options) do
  contact = Contact.last

  puts contact.inspect
end

# And everything get's cleaned up behind you.
defined? Contact # => nil
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
