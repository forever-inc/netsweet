# Netsweet

## Installation

Add this line to your application's Gemfile:

    gem 'netsweet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install netsweet

## Configuration

You must create a `.env.sandbox` with all the appropriate configuration parameters. NetSuite is a fairly complex beast, so the Netsweet gem will attempt live calls to test your integration.

Sample Configuration File:

```yaml
SANDBOX: true
API_VERSION: 2012_1

ECID: 1234567
PID: 1234567
ACCOUNT: 1234567_SB2

REST_USERID: dev@your_company.com
REST_PASSWORD: secure_password
SOAP_USERID: dev@your_company.com
SOAP_PASSWORD: secure_password
ROLE: 3
CUSTOMER_ACCESS_ROLE: 1017

HOST: https://system.sandbox.netsuite.com
WSDL_HOST: https://webservices.sandbox.netsuite.com
STORE_HOST: https://checkout.netsuite.com

PRIVATE_KEY_PATH: ./key.pem
PRIVATE_KEY_PASSPHRASE: secure_passphrase

REVOLUTION_PREP_LOG_PATH: log/netsuite.log
```

## Usage

Once you have your configuration file ready, you can load the `sandbox` environment using:

```bash
$ bin/console
Netsweet v0.0.1 loaded in sandbox mode.
[1] pry(main)>
```

With an optional environment parameter. This is useful given the state of NetSuite's Sandbox servers.

```bash
$ bin/console production
Netsweet v0.0.1 loaded in production mode.
[1] pry(main)>
```

You can now use Netsweet live against your environment:

```ruby
> user_attrs = { external_id: '1', entity_id: 'John Doe', email: 'john.doe@example.com', first_name: 'John', last_name: 'Doe', is_person: true }
> customer = Netsweet::Customer.create(user_attrs)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


# Dependencies

* `RevolutionPrep`: SOAP Interface to the Netsuite Web API.
    * `NetSuite::Records::Customer`
* `AcumenBrands`: RESTlet Wrapper. Both Ruby side client code as well as Server Side Javascript needed to implement the Netsuite RESTlet.
    * `Netsuite::Client`
* `SOAP4r`: Generic Netsuite SSO code. Gobs of generated Ruby code. Used for MapSSO.
    * `ForeverNetsuiteWrapper`

# Questions for NetSuite (Charlie)

* "system.na1.netsuite.com" vs "system.netsuite.com"
    # TODO: total price of a membership is the sume of items 7, 9, and 10


