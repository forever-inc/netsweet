# Netsweet

# Dependencies

* `RevolutionPrep`: SOAP Interface to the Netsuite Web API.
    * `NetSuite::Records::Customer`
* `AcumenBrands`: RESTlet Wrapper. Both Ruby side client code as well as Server Side Javascript needed to implement the Netsuite RESTlet.
    * `Netsuite::Client`
* `SOAP4r`: Generic Netsuite SSO code. Gobs of generated Ruby code. Used for MapSSO.
    * `ForeverNetsuiteWrapper`


* Get price of an item
* Grab NS customer record
* Map our Purchaser/User record to a NS customer.
* MapSSO auth tokens
* Delete NS customer record (mostly for testing)


# Questions for NetSuite (Charlie)

* "system.na1.netsuite.com" vs "system.netsuite.com"
    # TODO: total price of a membership is the sume of items 7, 9, and 10


## Installation

Add this line to your application's Gemfile:

    gem 'netsweet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install netsweet

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
